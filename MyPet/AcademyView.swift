//
//  AcademyView.swift
//  MyPet
//
//  Created by SDC-USER on 24/02/26.
//

import SwiftUI

struct AcademyView: View {
    // Premium Purple Palette to match HomeView
    let brandPurple = Color(hex: "8E2DE2")
    let backgroundColor = Color(hex: "F8F9FB")
    
    var body: some View {
        NavigationStack {
            ZStack {
                // --- MATCHING PURPLE GRADIENT BACKGROUND ---
                LinearGradient(
                    gradient: Gradient(colors: [
                        brandPurple.opacity(0.12), // Soft purple at top
                        brandPurple.opacity(0.04),
                        backgroundColor
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // --- 1. FEATURED SECTION (PURPLE THEME) ---
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Mastering Husky Care")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottomLeading) {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(brandPurple.gradient) // High-fidelity purple gradient
                                    .frame(height: 180)
                                    .shadow(color: brandPurple.opacity(0.3), radius: 15, x: 0, y: 10)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Husky Exercise 101")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                    Text("Learn how much motion a puppy needs daily.")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .padding(25)
                            }
                            .padding(.horizontal)
                        }
                        
                        // --- 2. CATEGORIES (PURPLE ACCENTS) ---
                        VStack(alignment: .leading, spacing: 18) {
                            Text("Essential Guides")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .padding(.horizontal)
                            
                            VStack(spacing: 16) {
                                // 1. Cost Simulator
                                NavigationLink(destination: CostSimulatorView()) {
                                    TopicCardPurple(title: "Cost of Ownership",
                                              desc: "Simulate monthly food, vet, and insurance costs.",
                                              icon: "chart.line.uptrend.xyaxis",
                                              color: brandPurple)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // 2. Navigation to Apartment Living
                                NavigationLink(destination: AcademyDetailView(
                                    title: "Apartment Living",
                                    content: """
                                    Huskies are legendary for their energy, but they CAN thrive in apartments if you are committed to their needs.
                                    
                                    • Space Requirements: You don't need a mansion, but you do need "pacing room." Ensure your layout allows for clear movement.
                                    
                                    • The Noise Factor: Huskies "woo-woo" and howl. In an apartment, this can lead to noise complaints. Use sound-absorbing rugs and work on "quiet" commands early.
                                    
                                    • Exercise is Non-Negotiable: Without a yard, you must provide at least 2 hours of vigorous activity daily. If they are tired indoors, they are well-behaved indoors.
                                    
                                    • Mental Stimulation: In small spaces, boredom leads to destruction. Use puzzle feeders and nose-work games to keep their minds busy.
                                    """)) {
                                        TopicCardPurple(title: "Apartment Living",
                                                  desc: "Is a Husky right for your space? Take the test.",
                                                  icon: "house.and.flag.fill",
                                                  color: .indigo)
                                }
                                .buttonStyle(PlainButtonStyle())

                                // 3. Navigation to Grooming
                                NavigationLink(destination: AcademyDetailView(
                                    title: "Grooming & Shedding",
                                    content: """
                                    The Siberian Husky has a dense double coat consisting of a straight topcoat and a soft, thick undercoat.
                                    
                                    • The "Blow Out": Twice a year, Huskies lose their entire undercoat. During this time, you will need to brush them daily to prevent "tumbleweeds" of fur in your home.
                                    
                                    • Weekly Maintenance: Outside of shedding season, a thorough brushing once or twice a week is usually enough to keep the coat healthy.
                                    
                                    • Never Shave a Husky: Their coat regulates their temperature in both heat and cold. Shaving them can cause permanent coat damage and skin issues.
                                    
                                    • Bathing: Huskies are relatively "self-cleaning" and don't have a strong doggy odor. Only bathe them every 3–4 months or when they get into something messy.
                                    """)) {
                                        TopicCardPurple(title: "Grooming & Shedding",
                                                  desc: "How to manage that thick double-coat.",
                                                  icon: "comb.fill",
                                                  color: brandPurple)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.vertical)
                    .padding(.bottom, 100) // Padding for TabBar
                }
            }
            .navigationTitle("Pet Academy")
        }
    }
}

// MARK: - Updated Purple Topic Card
struct TopicCardPurple: View {
    let title: String
    let desc: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Container with theme color
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(color.opacity(0.1))
                    .frame(width: 54, height: 54)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "1A1C1E"))
                
                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color.opacity(0.3))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}
// This view displays the content when you tap an "Essential Guide" card
struct AcademyDetailView: View {
    let title: String
    let content: String
    
    // Using the same palette for consistency
    let brandPurple = Color(hex: "8E2DE2")
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Image Placeholder or Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(brandPurple.opacity(0.1))
                        .frame(height: 150)
                    
                    Image(systemName: "book.pages.fill")
                        .font(.system(size: 60))
                        .foregroundColor(brandPurple)
                }
                
                Text(title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "1A1C1E"))
                
                Divider()
                
                Text(content)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .lineSpacing(6)
                    .foregroundColor(.secondary)
            }
            .padding(24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(hex: "F8F9FB").ignoresSafeArea())
    }
}
