//
//  Gallery_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct Gallery_Screen: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("🖼️ Gallery Screen")
            NavigationLink("Go to Cake Detail", destination: CakeDetail_Screen())
        }
    }
}
