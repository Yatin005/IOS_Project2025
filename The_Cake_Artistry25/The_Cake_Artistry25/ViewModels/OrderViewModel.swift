//
//  OrderViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//

import Foundation

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class OrderViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    var userId: String?
    
    init(userId: String? = nil) {
        self.userId = userId
        fetchOrders()
    }
    
    func fetchOrders() {
        guard let userId = userId else { return }
        
        isLoading = true
        db.collection("orders")
            .whereField("customerId", isEqualTo: userId)
            .getDocuments { [weak self] snapshot, error in
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                self?.orders = snapshot?.documents.compactMap { document in
                    try? document.data(as: Order.self)
                } ?? []
            }
    }
    
    func placeOrder(cake: Cake, quantity: Int, deliveryDate: Date, customerId: String) {
        isLoading = true
        let newOrder = Order(
            id: UUID().uuidString,
            cake: cake,
            quantity: quantity,
            customerId: customerId,
            deliveryDate: deliveryDate,
            status: "Processing"
        )
        
        do {
            try db.collection("orders").document(newOrder.id).setData(from: newOrder) { [weak self] error in
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.orders.append(newOrder)
                }
            }
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    func updateOrderStatus(orderId: String, newStatus: String) {
        guard let index = orders.firstIndex(where: { $0.id == orderId }) else { return }
        
        isLoading = true
        db.collection("orders").document(orderId).updateData(["status": newStatus]) { [weak self] error in
            self?.isLoading = false
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.orders[index].status = newStatus
            }
        }
    }
    
    func totalPrice() -> Double {
        orders.reduce(0) { $0 + ($1.cake.price * Double($1.quantity)) }
    }
    
    func ordersByStatus(_ status: String) -> [Order] {
        orders.filter { $0.status == status }
    }
}
