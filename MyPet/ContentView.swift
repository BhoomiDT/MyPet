//
//  ContentView.swift
//  MyPet
//
//  Created by SDC-USER on 12/02/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PetViewModel()
    @State private var hasStarted = false
    
    var body: some View {
        ZStack {
            if !hasStarted {
                HomeView(viewModel: viewModel)
                    .transition(.move(edge: .leading))
            } else {
                // The AR Space
                ZStack {
                    ARPetView(viewModel: viewModel)
                        .ignoresSafeArea()
                    
                    VStack {
                        // Top HUD (Stats)
                        HStack {
                            StatPill(label: "Training", value: viewModel.trainingLevel)
                            Spacer()
                            Text(viewModel.petName).bold().padding().background(.ultraThinMaterial).cornerRadius(15)
                        }
                        .padding()
                        
                        Spacer()
                        
                        // Interaction Panel
                        VStack(spacing: 15) {
                            ColorPicker("Fur Color", selection: $viewModel.furColor)
                            
                            Button(action: { viewModel.train() }) {
                                Label("Train Pet", systemImage: "figure.walk")
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
            }
        }
        .animation(.spring(), value: hasStarted)
    }
}

struct StatPill: View {
    let label: String
    let value: Double
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.caption).bold()
            ProgressView(value: value).frame(width: 80)
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
