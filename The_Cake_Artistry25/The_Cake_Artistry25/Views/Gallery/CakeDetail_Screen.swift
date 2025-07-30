//
//  CakeDetail_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
import SwiftUI

struct CakeDetailScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var cake: Cake
    @State private var customization = ""
    @State private var quantity = 1
    @State private var showAlert = false
    
    @StateObject var orderVM = OrderViewModel()

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: cake.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }.frame(height: 200)

            Text(cake.name).font(.title)
            Text(cake.description)

            TextField("Customization", text: $customization)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)

            if orderVM.isPlacingOrder {
                ProgressView("Placing Order...")
            } else {
                Button("Order Now") {
                    guard let userID = authViewModel.user?.id else { return }
                    let order = Order(
                        id: UUID().uuidString,
                        cakeID: cake.id,
                        userID: userID,
                        quantity: quantity,
                        timestamp: Date(),
                        customization: customization
                    )
                    orderVM.placeOrder(order: order)
                    showAlert = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(orderVM.orderError == nil ? "Order Placed!" : "Order Failed"),
                message: Text(orderVM.orderError?.localizedDescription ?? "Your order has been placed successfully."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
