//
//  OrderViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//

import Foundation
import FirebaseFirestore
import Combine

class OrderViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isPlacingOrder = false
    @Published var orderError: Error?
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func fetchOrders(for userID: String) {
        // Stop listening for old data if the user changes
        listenerRegistration?.remove()
        
        // Listen for real-time updates for the current user's orders
        listenerRegistration = db.collection("orders")
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                guard let documents = querySnapshot?.documents else {
                    print("No documents found or an error occurred: \(error?.localizedDescription ?? "Unknown error")")
                    self.orderError = error
                    return
                }
                
                // Map the documents to your Order model using Codable support
                self.orders = documents.compactMap { try? $0.data(as: Order.self) }
                print("Fetched \(self.orders.count) orders.")
            }
    }
    
    func placeOrder(order: Order) {
        self.isPlacingOrder = true
        self.orderError = nil
        
        do {
            _ = try db.collection("orders").addDocument(from: order) { [weak self] error in
                guard let self = self else { return }
                self.isPlacingOrder = false
                if let error = error {
                    self.orderError = error
                    print("Error placing order: \(error.localizedDescription)")
                } else {
                    print("Order placed successfully.")
                }
            }
        } catch {
            self.isPlacingOrder = false
            self.orderError = error
            print("Error adding document: \(error.localizedDescription)")
        }
    }
    
    deinit {
        // Remove the listener when the ViewModel is deallocated
        listenerRegistration?.remove()
    }
}
