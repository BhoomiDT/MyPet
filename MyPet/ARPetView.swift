//
//  ARPetView.swift
//  MyPet
//
//  Created by SDC-USER on 12/02/26.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARPetView: UIViewRepresentable {
    @ObservedObject var viewModel: PetViewModel

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // 1. World Tracking: Detects floors and walls
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        
        // 2. Occlusion: Makes the pet go BEHIND your hand or furniture
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        arView.session.run(config)
        
        // Tap Gesture to place/move the pet
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        arView.addGestureRecognizer(tap)
        
        context.coordinator.arView = arView
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // This ensures if you change colors or trigger actions in the UI,
        // the 3D pet updates instantly
        context.coordinator.performAction(viewModel.currentAction)
        context.coordinator.updatePetAppearance()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject {
        var arView: ARView?
        var viewModel: PetViewModel
        
        // Members for tracking the loaded dog
        var petEntity: Entity?
        var currentAnchor: AnchorEntity?
        var cancellables = Set<AnyCancellable>()

        init(viewModel: PetViewModel) {
            self.viewModel = viewModel
        }

        // --- THE MOVEMENT LOGIC (Moved inside Coordinator) ---
        func performAction(_ action: PetViewModel.PetAction) {
            guard let pet = petEntity else { return }

            switch action {
            case .walking:
                // Now 'pet.forward' will be recognized!
                var newTransform = pet.transform
                newTransform.translation += pet.forward * 0.3
                
                pet.move(to: newTransform,
                         relativeTo: pet.parent,
                         duration: 2.0,
                         timingFunction: AnimationTimingFunction.easeInOut)
                
            case .beingCalmed:
                let subtleScale = pet.scale * 1.02
                pet.move(to: Transform(scale: subtleScale, rotation: pet.orientation, translation: pet.position),
                         relativeTo: pet.parent,
                         duration: 0.6)
                
            case .idle:
                if let animation = pet.availableAnimations.first {
                    pet.playAnimation(animation.repeat())
                }
            }
        }

        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = arView, let _ = viewModel.selectedPet else { return }
            let location = sender.location(in: arView)
            
            // Raycast looks for a real floor surface
            if let result = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first {
                
                // CASE 1: Pet already exists -> Move it to the new spot (No duplicates!)
                if let existingPet = petEntity {
                    currentAnchor?.removeFromParent()
                    
                    let newAnchor = AnchorEntity(world: result.worldTransform)
                    newAnchor.addChild(existingPet)
                    arView.scene.addAnchor(newAnchor)
                    self.currentAnchor = newAnchor
                    
                    print("Dog moved to new location.")
                    return
                }

                // CASE 2: Loading the pet for the first time
                // Guard against multiple simultaneous loads
                if !cancellables.isEmpty && petEntity == nil { return }

                Entity.loadModelAsync(named: "Husky_Puppy")
                    .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] loadedModel in
                        guard let self = self else { return }
                        
                        // Scale: 0.005 is a realistic "puppy size"
                        loadedModel.scale = [0.005, 0.005, 0.005]
                        
                        let anchor = AnchorEntity(world: result.worldTransform)
                        anchor.addChild(loadedModel)
                        arView.scene.addAnchor(anchor)
                        
                        self.petEntity = loadedModel
                        self.currentAnchor = anchor
                        
                        // Apply colors and start idle animation
                        self.updatePetAppearance()
                        if let animation = loadedModel.availableAnimations.first {
                            loadedModel.playAnimation(animation.repeat())
                        }
                    })
                    .store(in: &self.cancellables)
            }
        }

        func updatePetAppearance() {
            let currentFurColor = viewModel.furColor
            let currentEyeColor = viewModel.eyeColor
            
            guard let pet = petEntity else { return }
            
            var furMat = PhysicallyBasedMaterial()
            furMat.baseColor = .init(tint: UIColor(currentFurColor))
            furMat.roughness = 1.0
            furMat.metallic = 0.0
            
            var eyeMat = PhysicallyBasedMaterial()
            eyeMat.baseColor = .init(tint: UIColor(currentEyeColor))
            eyeMat.roughness = 0.1
            eyeMat.metallic = 0.5
            
            pet.enumerateHierarchy { entity, _ in
                if let modelPart = entity as? ModelEntity {
                    // Using case-insensitive search for flexible model naming
                    if modelPart.name.lowercased().contains("eye") {
                        modelPart.model?.materials = [eyeMat]
                    } else {
                        modelPart.model?.materials = [furMat]
                    }
                }
            }
        }
    }
}

// --- ESSENTIAL EXTENSION ---
extension Entity {
    var forward: SIMD3<Float> {
        // This takes the standard "forward" vector (0,0,1)
        // and applies the pet's current rotation to it
        return orientation.act(SIMD3<Float>(0, 0, 1))
    }

    func enumerateHierarchy(_ closure: (Entity, UnsafeMutablePointer<Bool>) -> Void) {
        var stop = false
        closure(self, &stop)
        if stop { return }
        for child in children {
            child.enumerateHierarchy(closure)
        }
    }
}
