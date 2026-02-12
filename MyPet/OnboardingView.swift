//
//  OnboardingView.swift
//  MyPet
//
//  Created by SDC-USER on 12/02/26.
//

import SwiftUI

struct OnboardingView: View {
    var onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Pet Readiness")
                .font(.system(.largeTitle, design: .rounded)).bold()
            
            VStack(alignment: .leading, spacing: 20) {
                GuideRow(icon: "clock", text: "Dogs need 2+ hours of active attention daily.")
                GuideRow(icon: "house", text: "Ensure you have a pet-safe environment.")
                GuideRow(icon: "leaf", text: "Virtual pets are a great way to test your routine!")
            }
            .padding()
            
            Button("I'm Ready to Adopt") {
                onComplete()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

struct GuideRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.orange).font(.title2)
            Text(text).font(.subheadline)
        }
    }
}
