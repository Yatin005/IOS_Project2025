//
//  CheckoutViewModel.swift
//  The_Cake_Artistry25
//
//  Updated by Gemini on 2025-08-01.
//

import Foundation
import Combine

class CheckoutViewModel: ObservableObject {
    @Published var isProcessingOrder = false
    @Published var orderSuccess = false
    @Published var checkoutError: Error?

    private var orderViewModel: OrderViewModel
    private var authViewModel: AuthViewModel
    
    private var cancellables = Set<AnyCancellable>()

    init(orderViewModel: OrderViewModel, authViewModel: AuthViewModel) {
        self.orderViewModel = orderViewModel
        self.authViewModel = authViewModel
        
        orderViewModel.$isPlacingOrder
            .assign(to: \.isProcessingOrder, on: self)
            .store(in: &cancellables)
            
        orderViewModel.$orderError
            .assign(to: \.checkoutError, on: self)
            .store(in: &cancellables)
    }

    func checkout(
        cake: Cake,
        quantity: Int,
        flavor: String,
        orderDate: Date,
        orderTime: Date,
        customization: String,
        address: String?
    ) {
        self.orderSuccess = false
        self.checkoutError = nil
        
        guard let user = authViewModel.user else {
            self.checkoutError = NSError(domain: "CheckoutError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])
            return
        }
        
        guard let cakeID = cake.id else {
            self.checkoutError = NSError(domain: "CheckoutError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Cake ID not found. Cannot place order."])
            return
        }
        
        let totalPrice = cake.price * Double(quantity)

        let newOrder = Order(
            cakeID: cakeID,
            userID: user.id,
            quantity: quantity,
            timestamp: Date(),
            customization: customization,
            flavor: flavor,
            totalPrice: totalPrice,
            address: address, // Moved to the correct position
            orderDate: orderDate,
            
        )

        self.orderViewModel.placeOrder(order: newOrder)
        
        orderViewModel.$isPlacingOrder
            .filter { !$0 }
            .first()
            .sink { [weak self] _ in
                if self?.orderViewModel.orderError == nil {
                    self?.orderSuccess = true
                    print("✅ Order placed successfully!")
                } else {
                    print("❌ Error placing order.")
                }
            }
            .store(in: &cancellables)
    }
}
