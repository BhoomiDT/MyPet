//
//  PetViewModel.swift
//  MyPet
//
//  Created by SDC-USER on 12/02/26.
//
import SwiftUI
import Combine

// 1. The blueprint stays outside the class
struct PetProfile: Identifiable {
    let id = UUID()
    var name: String
    var species: String
    var breed: String
    var furColor: Color
    var eyeColor: Color
    var tailShape: String
    var earShape: String
    var trainingLevel: Double = 0.0
    var isFed: Bool = false
    var isWalked: Bool = false
}

class PetViewModel: ObservableObject {
    @Published var pets: [PetProfile] = []
    @Published var selectedPet: PetProfile?
    @Published var currentAction: PetAction = .idle
    
    @Published var furColor: Color = .brown
    @Published var eyeColor: Color = .blue
    @Published var petName: String = "Buddy"
    @Published var trainingLevel: Double = 0.0

    // --- ENUM INSIDE CLASS ---
    enum PetAction {
        case idle, walking, beingCalmed
    }

    // --- ACTIONS INSIDE CLASS ---
    func requestMove() {
        currentAction = .walking
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.currentAction = .idle
        }
    }

    func requestCalm() {
        currentAction = .beingCalmed
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.currentAction = .idle
        }
    }

    // --- MANAGEMENT METHODS INSIDE CLASS ---
    func addPet(_ pet: PetProfile) {
        pets.append(pet)
        selectPet(pet)
    }

    func selectPet(_ pet: PetProfile) {
        selectedPet = pet
        furColor = pet.furColor
        eyeColor = pet.eyeColor
        petName = pet.name
        trainingLevel = pet.trainingLevel
    }

    func train() {
        if trainingLevel < 1.0 {
            trainingLevel += 0.1
            if let index = pets.firstIndex(where: { $0.id == selectedPet?.id }) {
                pets[index].trainingLevel = trainingLevel
            }
        }
    }

    func deletePet(at indexSet: IndexSet) {
        pets.remove(atOffsets: indexSet)
    }

    func deletePet(_ pet: PetProfile) {
        pets.removeAll(where: { $0.id == pet.id })
        if selectedPet?.id == pet.id {
            selectedPet = nil
        }
    }
} 
