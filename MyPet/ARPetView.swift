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
        // This ensures if you change colors in the UI, the 3D pet updates instantly
        context.coordinator.updatePetAppearance()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject {
        var arView: ARView?
        var viewModel: PetViewModel
        
        // --- THE MISSING MEMBERS (Fixed the Error) ---
        var petEntity: Entity?
        var currentAnchor: AnchorEntity?
        var cancellables = Set<AnyCancellable>()

        init(viewModel: PetViewModel) {
            self.viewModel = viewModel
        }

        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = arView, let petSpecs = viewModel.selectedPet else { return }
            let location = sender.location(in: arView)
            
            // Raycast looks for a real floor surface
            if let result = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first {
                
                // CASE 1: Pet already exists -> Move it to the new spot
                if let existingPet = petEntity {
                    currentAnchor?.removeFromParent() // Clear old physical lock
                    
                    let newAnchor = AnchorEntity(world: result.worldTransform)
                    newAnchor.addChild(existingPet)
                    arView.scene.addAnchor(newAnchor)
                    self.currentAnchor = newAnchor
                    return
                }

                // CASE 2: Loading the pet for the first time
                Entity.loadModelAsync(named: "Husky_Puppy")
                    .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] loadedModel in
                        guard let self = self else { return }
                        
                        // Scale: 0.005 is a realistic "puppy size"
                        loadedModel.scale = [0.005, 0.005, 0.005]
                        
                        // Lock to the real-world floor position
                        let anchor = AnchorEntity(world: result.worldTransform)
                        anchor.addChild(loadedModel)
                        arView.scene.addAnchor(anchor)
                        
                        self.petEntity = loadedModel
                        self.currentAnchor = anchor
                        
                        // Apply Fur/Eye colors immediately
                        self.updatePetAppearance()
                        
                        // Start the breathing/wagging animation
                        if let animation = loadedModel.availableAnimations.first {
                            loadedModel.playAnimation(animation.repeat())
                        }
                    })
                    .store(in: &self.cancellables)
            }
        }

        func updatePetAppearance() {
            guard let pet = petEntity, let petSpecs = viewModel.selectedPet else { return }
            
            // Fur: Soft, non-metallic look
            var furMat = PhysicallyBasedMaterial()
            furMat.baseColor = .init(tint: UIColor(petSpecs.furColor))
            furMat.roughness = 1.0
            furMat.metallic = 0.0
            
            // Eyes: Shiny and wet look
            var eyeMat = PhysicallyBasedMaterial()
            eyeMat.baseColor = .init(tint: UIColor(petSpecs.eyeColor))
            eyeMat.roughness = 0.1
            
            // Search every part of the 3D model (Hierarchy)
            pet.enumerateHierarchy { entity, _ in
                if let modelPart = entity as? ModelEntity {
                    if modelPart.name == "eyes_3" {
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
// This allows RealityKit to look inside the Husky file's "hidden folders" to find the eyes
extension Entity {
    func enumerateHierarchy(_ closure: (Entity, UnsafeMutablePointer<Bool>) -> Void) {
        var stop = false
        closure(self, &stop)
        if stop { return }
        for child in children {
            child.enumerateHierarchy(closure)
        }
    }
}
