//
//  CakeDetail_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct CakeDetail_Screen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Cake Detail Screen")
            NavigationLink("Go to Customization", destination: Customization_Screen())
        }
        .padding()
    }
}

#Preview {
    CakeDetail_Screen()
}

