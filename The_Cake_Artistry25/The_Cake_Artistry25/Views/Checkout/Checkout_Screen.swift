//
//  Checkout_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct Checkout_Screen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text(" Checkout Screen")
            NavigationLink("Go to Order Tracking", destination: OrderTracking_Screen())
        }
        .padding()
    }
}

#Preview {
    Checkout_Screen()
}
