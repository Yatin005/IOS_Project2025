//
//  Login_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct Login_Screen: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("🔐 Login Screen")
                .font(.title)

            NavigationLink("Go to Home", destination: Home_Screen())
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    Login_Screen()
}
