//
//  CakeViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//

import Foundation

struct CakeViewModel: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let description: String
    let price: Double
}
