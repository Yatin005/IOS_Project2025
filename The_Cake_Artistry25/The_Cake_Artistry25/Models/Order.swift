//
//  Order.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//
import Foundation

struct Order: Identifiable, Codable {
    var id: String
    var cakeID: String
    var userID: String
    var quantity: Int
    var timestamp: Date
    var customization: String
}
