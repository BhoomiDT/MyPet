//
//  CostSimulatorView.swift
//  MyPet
//
//  Created by SDC-USER on 24/02/26.
//

import SwiftUI

struct CostSimulatorView: View {
    // State variables to drive the math
    @State private var isPremiumFood = false
    @State private var includesInsurance = true
    @State private var qualityLevel: Double = 1.0
    
    // Dynamic Calculation Logic
    var monthlyTotal: Int {
        let baseFood = isPremiumFood ? 80 : 40
        let insurance = includesInsurance ? 35 : 0
        let toys = Int(qualityLevel * 15)
        return baseFood + insurance + toys
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // --- TOTAL COST DISPLAY ---
                    VStack(spacing: 8) {
                        Text("Estimated Monthly Cost")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("$\(monthlyTotal)")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Based on your Husky's needs")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(LinearGradient(colors: [.mint, .teal], startPoint: .topLeading, endPoint: .bottomTrailing))
                    )
                    .padding()

                    // --- INTERACTIVE FACTORS ---
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Budget Factors")
                            .font(.system(.title3, design: .rounded).bold())
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            CostToggleRow(title: "Premium Protein Diet", isOn: $isPremiumFood, icon: "fork.knife", color: .orange)
                            CostToggleRow(title: "Full Health Insurance", isOn: $includesInsurance, icon: "cross.case.fill", color: .red)
                            
                            // Quality Slider
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Image(systemName: "sparkles").foregroundColor(.purple)
                                    Text("Toy & Gear Quality").font(.subheadline).bold()
                                    Spacer()
                                    Text(qualityLevel > 2 ? "Luxury" : "Standard").font(.caption).bold().foregroundColor(.secondary)
                                }
                                
                                Slider(value: $qualityLevel, in: 1...3, step: 1)
                                    .tint(.mint)
                                
                                HStack {
                                    Text("Basic").font(.caption).foregroundColor(.secondary)
                                    Spacer()
                                    Text("Premium").font(.caption).foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                        .padding(.horizontal)
                    }
                    
                    // --- PRO TIP CARD ---
                    HStack(spacing: 15) {
                        Image(systemName: "lightbulb.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                        
                        Text("Huskies are high-energy! Investing in durable puzzles and chew toys prevents 'destructive boredom' and saves you money on furniture repairs.")
                            .font(.system(.footnote, design: .rounded))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.orange.opacity(0.08)))
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Cost Simulator")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Sub-component for the rows
struct CostToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon).foregroundColor(color).font(.system(size: 16, weight: .bold))
            }
            
            Text(title)
                .font(.system(.body, design: .rounded).bold())
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .mint))
                .labelsHidden()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}
