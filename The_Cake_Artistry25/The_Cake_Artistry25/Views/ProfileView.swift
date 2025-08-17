//
//  ProfileView.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-08-01.
//

import SwiftUI

struct ProfileView: View {
    // This view expects an AuthViewModel to be provided in the environment.
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Display profile information if a user is signed in.
                if let user = authViewModel.user {
                    // The navigation title is now dynamic based on the user's name.
                    Text("Welcome, \(user.name)!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name: \(user.name)")
                        Text("Email: \(user.email)")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                } else {
                    // Show this message if no user is signed in.
                    Text("Please sign in.")
                }
                
                Spacer()
                
                // The sign out button is only visible if a user is signed in.
                if authViewModel.user != nil {
                    Button("Sign Out") {
                        authViewModel.signOut()
                    }
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Preview Provider (for easy testing in Xcode)

#Preview {
    // Create a mock view model for the preview to work.
    let mockAuthVM = AuthViewModel()
    
    return ProfileView()
        // Inject the mock view model into the preview environment.
        .environmentObject(mockAuthVM)
}
