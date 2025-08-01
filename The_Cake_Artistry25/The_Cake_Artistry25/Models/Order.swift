// Order.swift
import Foundation
import FirebaseFirestore

struct Order: Identifiable, Codable {
    @DocumentID var id: String?
    let cakeID: String
    let userID: String
    let quantity: Int
    let timestamp: Date
    let customization: String?
    let flavor: String
    let totalPrice: Double
}
