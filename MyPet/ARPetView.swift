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
        
        // Setup Plane Detection
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)
        
        // Tap Gesture to place pet
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        arView.addGestureRecognizer(tap)
        
        context.coordinator.arView = arView
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.updatePetColor()
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject {
        var arView: ARView?
        var viewModel: PetViewModel
        var petEntity: ModelEntity?

        init(viewModel: PetViewModel) {
            self.viewModel = viewModel
        }

        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = arView else { return }
            let location = sender.location(in: arView)
            
            if let result = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first {
                
                // Create Anchor
                let anchor = AnchorEntity(world: result.worldTransform)
                
                // Programmatic Pet (Capsule + Sphere)
                let bodyMesh = MeshResource.generateCylinder(height: 0.2, radius: 0.08)
                let material = SimpleMaterial(color: UIColor(viewModel.furColor), isMetallic: false)
                let pet = ModelEntity(mesh: bodyMesh, materials: [material])
                
                anchor.addChild(pet)
                arView.scene.addAnchor(anchor)
                self.petEntity = pet
            }
        }
        func updatePetColor() {
            guard let pet = petEntity else { return }
            
            let material = SimpleMaterial(color: UIColor(viewModel.furColor), isMetallic: false)
            pet.model?.materials = [material]
        }

    }
}
