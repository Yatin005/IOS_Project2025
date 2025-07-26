//
//  cake.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//

import Foundation
struct CakeData {
    static func getCakes(for category: String) -> [CakeViewModel] {
        switch category {
        case "🎂 Birthday Cakes":
            return [
                CakeViewModel(title: "Chocolate Cake", imageName: "birthday1", description: "Rich chocolate cake for birthdays.", price: 19.99),
                CakeViewModel(title: "Sprinkle Vanilla", imageName: "birthday2", description: "Vanilla cake topped with sprinkles.", price: 14.99)
            ]
        case "💍 Anniversary Cakes":
            return [
                CakeViewModel(title: "Red Velvet", imageName: "anniversary1", description: "Romantic red velvet delight.", price: 24.99)
            ]
        case "🎉 Festival Cakes":
            return [
                CakeViewModel(title: "Christmas Cake", imageName: "festival1", description: "Classic fruit cake for Christmas.", price: 20.99)
            ]
        case "❤️ Liked Cakes":
            return [
                CakeViewModel(title: "Oreo Cake", imageName: "liked1", description: "Cookies & Cream fun!", price: 16.49)
            ]
        default:
            return []
        }
    }
}
