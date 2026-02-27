//
//  PetSpecificationView.swift
//  MyPet
//
//  Created by SDC-USER on 13/02/26.
//

import SwiftUI

struct PetSpecificationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PetViewModel
    
    @State private var name = ""
    @State private var species = "Dog"
    @State private var color: Color = .brown
    @State private var tail = "Long"
    @State private var breed = "Husky"
    @State private var eyeColor: Color = .blue
    @State private var earShape = "Pointy"
    var body: some View {
        NavigationStack {
            Form {
                Section("Identity") {
                    TextField("Pet Name", text: $name)
                    Picker("Species", selection: $species) {
                        Text("Dog").tag("Dog"); Text("Cat").tag("Cat")
                    }
                }
                Section("Visuals") {
                    ColorPicker("Fur Color", selection: $color)
                    Picker("Tail Shape", selection: $tail) {
                        Text("Long").tag("Long"); Text("Short").tag("Short"); Text("Curled").tag("Curled")
                    }
                }
                Section("Breed & Characteristics") {
                    Picker("Breed", selection: $breed) {
                        Text("Husky").tag("Husky")
                        Text("Golden Retriever").tag("Retriever")
                    }
                    ColorPicker("Eye Color", selection: $eyeColor)
                    Picker("Ear Style", selection: $earShape) {
                        Text("Pointy").tag("Pointy")
                        Text("Dropped").tag("Dropped")
                    }
                }
                Button("Adopt & Start Training") {
                    let new = PetProfile(
                        name: name,
                        species: species,
                        breed: breed,
                        furColor: color,
                        eyeColor: eyeColor,
                        tailShape: tail,
                        earShape: earShape
                    )
                    viewModel.addPet(new) // Call directly, no $ prefix
                    dismiss()
                }
            }
            .navigationTitle("Pet Specifications")
        }
    }
}
