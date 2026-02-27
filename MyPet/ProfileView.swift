//
//  ProfileView.swift
//  MyPet
//
//  Created by SDC-USER on 27/02/26.
//


import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    let brandPurple = Color(hex: "8E2DE2")
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F8F9FB").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // --- 1. AVATAR SECTION ---
                        VStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(brandPurple.opacity(0.1))
                                    .frame(width: 120, height: 120)
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(brandPurple.gradient)
                            }
                            
                            VStack(spacing: 4) {
                                Text("Pet Parent")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                Text("Member since Feb 2026")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 20)

                        // --- 2. SETTINGS LIST ---
                        VStack(alignment: .leading, spacing: 0) {
                            ProfileRow(icon: "bell.fill", title: "Notifications", color: .blue)
                            Divider().padding(.leading, 55)
                            ProfileRow(icon: "shield.fill", title: "Privacy & Security", color: .green)
                            Divider().padding(.leading, 55)
                            ProfileRow(icon: "questionmark.circle.fill", title: "Help Center", color: .orange)
                        }
                        .background(Color.white)
                        .cornerRadius(24)
                        .padding(.horizontal)

                        // --- 3. LOGOUT BUTTON ---
                        Button(action: { dismiss() }) {
                            Text("Log Out")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.02), radius: 10, y: 5)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.bold)
                        .foregroundColor(brandPurple)
                }
            }
        }
    }
}

// Sub-component for clean rows
struct ProfileRow: View {
    let icon: String; let title: String; let color: Color
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.1)).frame(width: 36, height: 36)
                Image(systemName: icon).foregroundColor(color).font(.system(size: 14))
            }
            Text(title).font(.system(size: 16, weight: .medium, design: .rounded))
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 12, weight: .bold)).foregroundColor(.secondary.opacity(0.5))
        }
        .padding(16)
    }
}