//
//  Home_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct Home_Screen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("🏠 Home Screen")
                .font(.title)

            NavigationLink("Go to Gallery", destination: Gallery_Screen())
            NavigationLink("Go to Profile", destination: Profle_Screen())
        }
        .padding()
    }
}

#Preview {
    Home_Screen()
}
