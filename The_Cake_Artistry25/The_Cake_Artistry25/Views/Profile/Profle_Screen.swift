//
//  Profle_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
import SwiftUI

struct Profle_Screen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile Screen")
                .font(.largeTitle)
            
            if let user = authViewModel.user {
                Text("Logged in as: \(user.email)")
                    .font(.headline)
            }
            
            Button("Sign Out") {
                authViewModel.signOut()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding()
    }
}
