//
//  PetViewModel.swift
//  MyPet
//
//  Created by SDC-USER on 12/02/26.
//

import SwiftUI
import Combine

// The blueprint for every pet you create
struct PetProfile: Identifiable {
    let id = UUID()
    var name: String
    var species: String // Dog, Cat, etc.
    var breed: String
    var furColor: Color
    var eyeColor: Color
    var tailShape: String
    var earShape: String
    // Stats for the "Habit Tracker"
    var trainingLevel: Double = 0.0
    var isFed: Bool = false
    var isWalked: Bool = false
}

class PetViewModel: ObservableObject {
    @Published var pets: [PetProfile] = [] // Your collection of pets
    @Published var selectedPet: PetProfile? // The pet currently being viewed
    
    // These remain for the AR view to bind to easily
    @Published var furColor: Color = .brown
    @Published var petName: String = "Buddy"
    @Published var trainingLevel: Double = 0.0
    func addPet(_ pet: PetProfile) {
            pets.append(pet)
            // Automatically select the newest pet
            selectPet(pet)
        }
    func selectPet(_ pet: PetProfile) {
        selectedPet = pet
        furColor = pet.furColor
        petName = pet.name
        trainingLevel = pet.trainingLevel
    }

    func train() {
        if trainingLevel < 1.0 {
            trainingLevel += 0.1
            // Update the actual profile in the list
            if let index = pets.firstIndex(where: { $0.id == selectedPet?.id }) {
                pets[index].trainingLevel = trainingLevel
            }
        }
    }
}
