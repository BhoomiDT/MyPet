//
//  ARContainerView.swift
//  MyPet
//
//  Created by SDC-USER on 13/02/26.
//


import SwiftUI

struct ARContainerView: View {
    @ObservedObject var viewModel: PetViewModel
    
    var body: some View {
        ZStack {
            // Your existing AR camera view
            ARPetView(viewModel: viewModel)
                .ignoresSafeArea()
            
            // The User Interface overlaying the camera
            VStack {
                HStack {
                    StatPill(label: "Training", value: viewModel.trainingLevel)
                    Spacer()
                    Text(viewModel.petName)
                        .bold()
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                }
                .padding()
                
                Spacer()
                
                // Interaction Panel
                VStack(spacing: 15) {
                    Text("Interaction Mode")
                        .font(.headline)
                    
                    Button(action: { viewModel.train() }) {
                        Label("Practice Command", systemImage: "figure.walk")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(25)
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}