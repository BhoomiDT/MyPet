//
//  OnboardingView.swift
//  MyPet
//
//  Created by SDC-USER on 12/02/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: PetViewModel
    @State private var showingSpecs = false
    @State private var openAR = false
    
    var body: some View {
            ZStack {
                // Background Gradient
                LinearGradient(colors: [Color.mint.opacity(0.1), Color.white],
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // --- HEADER SECTION ---
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Hello, Explorer!")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundColor(.secondary)
                                Text("Your Companions")
                                    .font(.system(.largeTitle, design: .rounded).bold())
                            }
                            Spacer()
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.mint)
                        }
                        .padding(.horizontal)
                        
                        // --- PET CAROUSEL ---
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(viewModel.pets) { pet in
                                    PetCard(pet: pet)
                                        .onTapGesture {
                                            viewModel.selectPet(pet)
                                            openAR = true
                                        }
                                }
                                
                                // Add Pet Button with Glassmorphism
                                Button { showingSpecs = true } label: {
                                    VStack(spacing: 12) {
                                        Image(systemName: "plus")
                                            .font(.title.bold())
                                            .foregroundColor(.mint)
                                            .frame(width: 60, height: 60)
                                            .background(Circle().fill(Color.mint.opacity(0.1)))
                                        Text("Add New").font(.system(.callout, design: .rounded)).bold()
                                    }
                                    .frame(width: 150, height: 200)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(30)
                                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.mint.opacity(0.2), lineWidth: 1))
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // --- CARE HABITS ---
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Daily Care")
                                .font(.system(.title3, design: .rounded).bold())
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                HabitRow(title: "Nutrition Check", icon: "leaf.fill", color: .green, progress: 0.8)
                                HabitRow(title: "AR Exercise", icon: "figure.walk.motion", color: .blue, progress: 0.4)
                            }
                            .padding(.horizontal)
                        }
                        
                        // --- ACADEMY HIGHLIGHTS ---
                        // Locate the Pet Academy section at the bottom of HomeView
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Pet Academy")
                                .font(.system(.title3, design: .rounded).bold())
                                .padding(.horizontal)
                            
                            // Links to the full Academy list
                            NavigationLink(destination: AcademyView()) {
                                TopicCard(title: "The Husky Manual",
                                          desc: "Energy levels & climate needs.",
                                          icon: "book.closed.fill")
                            }
                            .buttonStyle(PlainButtonStyle())

                            // Links directly to the working Budget Calculator
                            NavigationLink(destination: CostSimulatorView()) {
                                TopicCard(title: "Budget Planner",
                                          desc: "Monthly cost for a Puppy.",
                                          icon: "creditcard.fill")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical)
                }
            }
            
            .sheet(isPresented: $showingSpecs) { PetSpecificationView(viewModel: viewModel) }
            .navigationDestination(isPresented: $openAR) { ARContainerView(viewModel: viewModel) }
        }
    }
struct PetCard: View {
    let pet: PetProfile
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                // Background shape
                RoundedRectangle(cornerRadius: 25)
                    .fill(LinearGradient(colors: [pet.furColor.opacity(0.6), pet.furColor], startPoint: .topLeading, endPoint: .bottomTrailing))
                
                Image(systemName: "pawprint.fill")
                    .padding()
                    .foregroundColor(.white.opacity(0.3))
                    .font(.title)
            }
            .frame(height: 120)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pet.name).font(.system(.headline, design: .rounded))
                Text(pet.species).font(.system(.caption, design: .rounded)).foregroundColor(.secondary)
            }
            .padding([.horizontal, .bottom])
        }
        .frame(width: 150, height: 200)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 10)
    }
}

struct HabitRow: View {
    let title: String; let icon: String; let color: Color; let progress: CGFloat
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(RoundedRectangle(cornerRadius: 12).fill(color))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(.subheadline, design: .rounded).bold())
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.gray.opacity(0.1)).frame(height: 6)
                        Capsule().fill(color).frame(width: geo.size.width * progress, height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 5)
    }
}
struct TopicCard: View {
    let title: String
    let desc: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Container
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(desc)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.orange.opacity(0.4))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}
