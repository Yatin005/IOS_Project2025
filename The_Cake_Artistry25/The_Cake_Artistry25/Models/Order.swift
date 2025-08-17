// Order.swift
import Foundation
import FirebaseFirestore
// Order.swift
import Foundation
import FirebaseFirestore

struct Order: Identifiable, Codable {
    @DocumentID var id: String? // Optional ID, let the backend (e.g., Firestore) generate it
    let cakeID: String
    let userID: String
    let quantity: Int
    let timestamp: Date
    let customization: String?
    let flavor: String
    let totalPrice: Double
    let address: String?
    let orderDate: Date
    
}
