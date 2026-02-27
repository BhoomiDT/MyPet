//
//  ARHubView.swift
//  MyPet
//
//  Created by SDC-USER on 27/02/26.
//
import SwiftUI

struct ARHubView: View {
    @ObservedObject var viewModel: PetViewModel
    @State private var isShowingCustomizer = false
    @State private var isShowingAR = false
    
    let brandPurple = Color(hex: "8E2DE2")
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F8F9FB").ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // --- 1. HEADER ---
                        VStack(alignment: .leading, spacing: 4) {
                            Text("AR PET WORLD")
                                .font(.system(size: 12, weight: .black))
                                .kerning(1.2)
                                .foregroundColor(.secondary)
                            Text("My 3D Collection")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                        }
                        .padding(.horizontal)

                        // --- 2. ADD PET CARD ---
                        Button {
                            isShowingCustomizer = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                VStack(alignment: .leading) {
                                    Text("Adopt a New Pet")
                                        .font(.headline)
                                    Text("Customize traits and start training")
                                        .font(.caption)
                                        .opacity(0.8)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding(24)
                            .background(brandPurple.gradient)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                        }
                        .padding(.horizontal)

                        // --- 3. PET GRID ---
                        Text("Active Profiles")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .padding(.horizontal)

                        if viewModel.pets.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "dog.fill")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.quaternary)
                                Text("Your sanctuary is empty.")
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 50)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                // Inside ARHubView body's ForEach:
                                ForEach(viewModel.pets) { pet in
                                    PetGridCard(
                                        pet: pet,
                                        isSelected: viewModel.selectedPet?.id == pet.id,
                                        onEdit: {
                                            viewModel.selectPet(pet)
                                            isShowingCustomizer = true // Re-use your modal for editing
                                        },
                                        onDelete: {
                                            // Simple direct delete, or trigger an alert
                                            withAnimation {
                                                viewModel.deletePet(pet)
                                            }
                                        }
                                    )
                                    .onTapGesture {
                                        viewModel.selectPet(pet)
                                        isShowingAR = true
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            
            // Sheet for Customization
            .sheet(isPresented: $isShowingCustomizer) {
                PetSpecificationView(viewModel: viewModel)
            }

            // Full screen camera view
            .fullScreenCover(isPresented: $isShowingAR) {
                // Ensure this struct exists in your project!
                ARPetView(viewModel: viewModel)
                    .ignoresSafeArea()
                    .overlay(alignment: Alignment.topTrailing) {
                        Button {
                            isShowingAR = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
            }
        }
    }
}

// Sub-component for the Grid Items
struct PetGridCard: View {
    let pet: PetProfile
    let isSelected: Bool
    var onEdit: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // --- Action Buttons ---
            HStack {
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(.gray.opacity(0.5))
                        .font(.system(size: 20))
                }
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red.opacity(0.7))
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)

            // --- Existing Content ---
            ZStack {
                Circle()
                    .fill(pet.furColor.opacity(0.2))
                    .frame(width: 60, height: 60)
                Image(systemName: "pawprint.fill")
                    .foregroundColor(pet.furColor)
            }
            
            VStack {
                Text(pet.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                Text(pet.breed)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, y: 5)
    }
}
