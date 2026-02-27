//
//  MainTabView.swift
//  MyPet
//
//  Created by SDC-USER on 24/02/26.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = PetViewModel()
    
    var body: some View {
        TabView {
            // TAB 1: Home wrapped in its own NavigationStack
            NavigationStack {
                HomeView(viewModel: viewModel)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            // TAB 2: AR
            ARContainerView(viewModel: viewModel)
                .tabItem {
                    Label("AR Play", systemImage: "arkit")
                }
            
            // TAB 3: Academy wrapped in its own NavigationStack
            NavigationStack {
                AcademyView()
            }
            .tabItem {
                Label("Academy", systemImage: "graduationcap.fill")
            }
        }
        .accentColor(.mint)
    }
}
