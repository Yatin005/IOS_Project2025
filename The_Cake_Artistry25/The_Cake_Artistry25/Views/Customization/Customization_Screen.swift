//
//  Customization_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct Customization_Screen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Customization Screen")
            NavigationLink("Go to Checkout", destination: Checkout_Screen())
        }
        .padding()
    }
}

#Preview {
    Customization_Screen()
}
