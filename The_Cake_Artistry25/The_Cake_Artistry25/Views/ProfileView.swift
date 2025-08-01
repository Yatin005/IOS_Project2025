//
//  ProfileView.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-08-01.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                if let user = authViewModel.user {
                    Text("User Profile")
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
                    Text("Please sign in.")
                }

                Spacer()
                
                Button("Sign Out") {
                    authViewModel.signOut()
                }
                .foregroundColor(.red)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}
#Preview {
    ProfileView()
}
