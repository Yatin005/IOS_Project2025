//
//  OrderViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//
import Foundation
import FirebaseFirestore

class OrderViewModel: ObservableObject {
    @Published var orderError: Error?
    @Published var isPlacingOrder = false

    func placeOrder(order: Order) {
        isPlacingOrder = true
        orderError = nil
        do {
            try Firestore.firestore().collection("orders").document(order.id).setData(from: order)
            isPlacingOrder = false
        } catch {
            print("Error placing order: \(error.localizedDescription)")
            isPlacingOrder = false
            orderError = error
        }
    }
}
