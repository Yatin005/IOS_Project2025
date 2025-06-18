//
//  Welcome_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct Welcome_Screen: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("🎂 Welcome to Cake Artistry 🎨")
                .font(.largeTitle)

            NavigationLink("Login", destination: Login_Screen())
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    Welcome_Screen()
}
