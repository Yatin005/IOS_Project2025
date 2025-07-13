//
//  Profle_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
import SwiftUI

struct Profle_Screen: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                if let user = authVM.user {
                    Section(header: Text("Profile Information")) {
                        Text("Name: \(user.name)")
                        Text("Email: \(user.email)")
                    }
                }
                
                Section {
                    Button("Sign Out") {
                        authVM.signOut()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("My Profile")
        }
    }
}

#Preview {
    Profle_Screen()
        .environmentObject(AuthViewModel())
}
