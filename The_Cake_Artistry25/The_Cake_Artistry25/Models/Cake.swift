//
//  Cake.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//
import Foundation
import FirebaseFirestore // Make sure to import this

struct Cake: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var imageUrl: String
    var price: Double
    var category: String
}
