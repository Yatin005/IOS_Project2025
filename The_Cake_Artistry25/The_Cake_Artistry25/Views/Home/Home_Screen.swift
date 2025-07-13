//
//  Home_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI


struct Home_Screen: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    Text("🏠 Home")
                        .font(.largeTitle)
                    
                    NavigationLink {
                        Gallery_Screen()
                    } label: {
                        HomeCardView(title: "Gallery", icon: "photo.on.rectangle", color: .blue)
                    }
                    
                    NavigationLink {
                        Profle_Screen()
                    } label: {
                        HomeCardView(title: "Profile", icon: "person.circle", color: .green)
                    }
                    
                    if authVM.user != nil {
                        Button("Sign Out") {
                            authVM.signOut()
                        }
                        .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct HomeCardView: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
            Text(title)
                .font(.title2)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
        .foregroundColor(color)
    }
}

#Preview {
    Home_Screen()
        .environmentObject(AuthViewModel())
}
