//
//  Cake.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//
import Foundation

struct Cake: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var imageUrl: String
    var price: Double
    var category: String
}
