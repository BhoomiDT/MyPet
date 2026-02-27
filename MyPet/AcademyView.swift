//
//  AcademyView.swift
//  MyPet
//
//  Created by SDC-USER on 24/02/26.
//

import SwiftUI

struct AcademyView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background matching your HomeView's fresh style
                LinearGradient(colors: [Color.orange.opacity(0.05), Color.white],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // --- FEATURED SECTION ---
                        VStack(alignment: .leading) {
                            Text("Mastering Husky Care")
                                .font(.system(.title2, design: .rounded).bold())
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottomLeading) {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(LinearGradient(colors: [Color.orange, Color.red.opacity(0.7)],
                                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(height: 180)
                                    .shadow(color: Color.orange.opacity(0.3), radius: 15, x: 0, y: 10)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Husky Exercise 101")
                                        .font(.title.bold())
                                        .foregroundColor(.white)
                                    Text("Learn how much motion a puppy needs daily.")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .padding(25)
                            }
                            .padding(.horizontal)
                        }
                        
                        // --- CATEGORIES ---
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Essential Guides")
                                .font(.system(.headline, design: .rounded))
                                .padding(.horizontal)
                            
                            // 1. Working Navigation to Cost Simulator
                            NavigationLink(destination: CostSimulatorView()) {
                                TopicCard(title: "Cost of Ownership",
                                          desc: "Simulate monthly food, vet, and insurance costs.",
                                          icon: "chart.line.uptrend.xyaxis")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // 2. Navigation to Apartment Living
                            NavigationLink(destination: AcademyDetailView(title: "Apartment Living", content: "Huskies are vocal and high-energy. Ensure you have at least 500sqft and active walking routes nearby.")) {
                                TopicCard(title: "Apartment Living",
                                          desc: "Is a Husky right for your space? Take the test.",
                                          icon: "house.and.flag.fill")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // 3. Navigation to Grooming
                            NavigationLink(destination: AcademyDetailView(title: "Grooming", content: "Huskies have a double coat. Brush at least 3 times a week to manage shedding.")) {
                                TopicCard(title: "Grooming & Shedding",
                                          desc: "How to manage that thick double-coat.",
                                          icon: "comb.fill")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Pet Academy")
        }
    }
}

// MARK: - Navigation Destination Components

struct AcademyDetailView: View {
    let title: String
    let content: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(title)
                    .font(.system(.largeTitle, design: .rounded).bold())
                Text(content)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
