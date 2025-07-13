//
//  Welcome_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

import SwiftUI

struct Welcome_Screen: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("🎂 Welcome to Cake Artistry 🎨")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Image("cake_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                NavigationLink("Login", destination: Login_Screen())
                    .buttonStyle(.borderedProminent)
                    .padding()
                
                NavigationLink("Browse as Guest", destination: Home_Screen())
                    .foregroundColor(.blue)
            }
            .padding()
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    Welcome_Screen()
}
