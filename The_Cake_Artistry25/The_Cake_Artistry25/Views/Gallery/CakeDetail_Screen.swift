//
//  CakeDetail_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct CakeDetailScreen: View {
    let cakeName: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "birthday.cake").resizable().scaledToFit().frame(height: 200).padding()
            Text(cakeName).font(.title).bold()
            Text("This is a delicious \(cakeName) perfect for your special moments.")
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("Cake Details")
    }
}


