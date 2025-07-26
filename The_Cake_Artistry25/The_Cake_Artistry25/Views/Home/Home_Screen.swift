//
//  Home_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
import SwiftUI

struct HomeScreen: View {
    let categories = ["Birthday", "Anniversary", "Festival", "Wedding", "Baby Shower"]

    var body: some View {
        NavigationView {
            List(categories, id: \.self) { category in
                NavigationLink(destination: CakeListScreen(category: category)) {
                    Text(category).font(.headline)
                }
            }
            .navigationTitle("Cake Albums")
        }
    }
}
