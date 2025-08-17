//
//  AppContentView.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
//
//  ContentView.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//
import SwiftUI

struct ContentView: View {
    // The AuthViewModel is created and owned by ContentView.
    // It will be the single source of truth for authentication state.
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            // Check if there is a logged-in user.
            if authViewModel.user != nil {
                // If a user is logged in, show the main application tab view.
                // We inject the authViewModel into the environment so child views can access it.
                MainTabView()
                    .environmentObject(authViewModel)
            } else {
                // If no user is logged in, show the welcome and authentication flow.
                // The WelcomeView will lead to the AuthView.
                WelcomeView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
