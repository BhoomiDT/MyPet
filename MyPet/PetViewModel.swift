//
//  PetViewModel.swift
//  MyPet
//
//  Created by SDC-USER on 12/02/26.
//

import SwiftUI
import Combine // <--- Add this to fix the red errors

class PetViewModel: ObservableObject {
    // Appearance
    @Published var furColor: Color = .brown
    @Published var petName: String = "Buddy"
    
    // Stats (The Training Aspect)
    @Published var hunger: Double = 1.0
    @Published var trainingLevel: Double = 0.0
    
    func train() {
        if trainingLevel < 1.0 {
            trainingLevel += 0.1
        }
    }
}
