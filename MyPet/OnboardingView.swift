//
//  OnboardingView.swift
//  MyPet
//
//  Created by SDC-USER on 12/02/26.
//
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: PetViewModel
    @State private var selectedMood: String? = "Calm"
    @State private var isShowingProfile = false
    // Premium Purple Palette
    let brandPurple = Color(hex: "8E2DE2")
    let backgroundColor = Color(hex: "F8F9FB")
    
    var body: some View {
        ZStack {
            LinearGradient(
                        gradient: Gradient(colors: [
                            brandPurple.opacity(0.18), // Soft purple at the top
                            brandPurple.opacity(0.05), // Fading down
                            backgroundColor            // Clean base at the bottom
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                // One main VStack controls the layout flow and global padding
                VStack(alignment: .leading, spacing: 32) {
                    
                    // --- 1. HEADER ---
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("FRIDAY, FEB 27")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.secondary)
                            Text("Pet Dashboard")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "1A1C1E"))
                        }
                        Spacer()
                        Button(action: { isShowingProfile = true }) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .foregroundStyle(brandPurple.gradient)
                        }
                    }

                    // --- 2. MOOD SELECTOR ---
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Current State")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        
                        HStack(spacing: 12) {
                            MoodButtonPurple(emoji: "😊", label: "Happy", isSelected: selectedMood == "Happy", color: brandPurple) { selectedMood = "Happy" }
                            MoodButtonPurple(emoji: "😌", label: "Calm", isSelected: selectedMood == "Calm", color: brandPurple) { selectedMood = "Calm" }
                            MoodButtonPurple(emoji: "🤩", label: "Active", isSelected: selectedMood == "Active", color: brandPurple) { selectedMood = "Active" }
                        }
                    }

                    // --- 3. DAILY KNOWLEDGE (Insights Card Restored) ---
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(brandPurple)
                                .font(.system(size: 14, weight: .bold))
                            Text("DAILY KNOWLEDGE")
                                .font(.system(size: 11, weight: .black))
                                .kerning(1.2)
                                .foregroundColor(.secondary)
                        }
                        Text("Huskies have a natural 'independent' streak. Consistent reinforcement is the best way to earn focus.")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "1A1C1E"))
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: Color.black.opacity(0.03), radius: 15, y: 10)

                    // --- 4. VITALS OVERVIEW (All 4 Cards Restored) ---
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Vitals Overview")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            StaticStatCard(title: "Training", value: "85%", icon: "bolt.fill", color: brandPurple)
                            StaticStatCard(title: "Hydration", value: "Optimal", icon: "drop.fill", color: .blue)
                            StaticStatCard(title: "Activity", value: "1.2h", icon: "figure.walk", color: .indigo)
                            StaticStatCard(title: "Wellness", value: "Great", icon: "heart.fill", color: .pink)
                        }
                    }

                    // --- 5. LATEST ARTICLES (High-Fidelity Cards) ---
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Articles")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        VStack(spacing: 24) {
                            LargeArticleCard(
                                title: "Mastering the Husky Coat",
                                description: "Learn the secrets to managing shedding and keeping that double coat healthy.",
                                imageName: "husky_grooming",
                                category: "Grooming",
                                color: brandPurple
                            )
                            
                            LargeArticleCard(
                                title: "Factors Impacting Training",
                                description: "Why environment and diet play a huge role in your dog's ability to focus.",
                                imageName: "husky_training",
                                category: "Training",
                                color: .indigo
                            )
                        }
                    }
                }
                .padding(.horizontal, 20) // Unified horizontal padding
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
        .sheet(isPresented: $isShowingProfile) {
                    ProfileView()
                }
    }
}

// MARK: - Updated Large Article Card (Removed internal horizontal padding)
struct LargeArticleCard: View {
    let title: String
    let description: String
    let imageName: String
    let category: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // IMAGE SECTION
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .clipped()
            }
            .background(color.opacity(0.1))
            
            // TEXT SECTION
            VStack(alignment: .leading, spacing: 8) {
                Text(category.uppercased())
                    .font(.system(size: 10, weight: .black))
                    .kerning(1.0)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "1A1C1E"))
                    .lineLimit(1)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
}

// Keep your existing StatCard, MoodButton and Color Hex extensions below...
// MARK: - Article Row Component
struct ArticleRow: View {
    let title: String
    let category: String
    let duration: String
    let imageName: String // Added image support
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // --- IMAGE THUMBNAIL ---
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(color.opacity(0.15))
                
                // Try to load the image, fallback to icon if missing
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Subtle overlay icon to indicate it's an article
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 12))
                    .foregroundColor(color)
                    .padding(4)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .offset(x: 22, y: 22)
            }
            .frame(width: 65, height: 65)
            
            // --- TEXT CONTENT ---
            VStack(alignment: .leading, spacing: 4) {
                Text(category.uppercased())
                    .font(.system(size: 10, weight: .black))
                    .kerning(1.0)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "1A1C1E"))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(duration + " read")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Interactive icon (Static as per your request)
            Image(systemName: "plus.circle.fill")
                .foregroundColor(color.opacity(0.3))
                .font(.system(size: 20))
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 4)
        .padding(.horizontal)
    }
}
// MARK: - Components
struct MoodButtonPurple: View {
    let emoji: String; let label: String; let isSelected: Bool; let color: Color; let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji).font(.system(size: 24))
                Text(label).font(.system(size: 10, weight: .black)).foregroundColor(isSelected ? .white : .gray)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 85)
            .background(isSelected ? color : Color.white)
            .cornerRadius(22)
            .shadow(color: isSelected ? color.opacity(0.2) : Color.black.opacity(0.04), radius: 8, y: 4)
        }
    }
}

struct StaticStatCard: View {
    let title: String; let value: String; let icon: String; let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle().fill(color.opacity(0.1)).frame(width: 32, height: 32)
                Image(systemName: icon).foregroundColor(color).font(.system(size: 14, weight: .bold))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(value).font(.system(size: 22, weight: .bold, design: .rounded)).foregroundColor(Color(hex: "1A1C1E"))
                Text(title).font(.system(size: 12, weight: .bold)).foregroundColor(.gray)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.02), radius: 10, x: 0, y: 5)
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
// MARK: - Helpers
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
