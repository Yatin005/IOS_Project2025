//
//  OrdersView.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-08-01.
//

import SwiftUI

struct OrdersView: View {
    // You would need a new view model to fetch orders for the current user
    // @StateObject private var viewModel = OrdersListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                // Placeholder for order items
                Text("Order 1: Chocolate Cake")
                Text("Order 2: Wedding Cake")
            }
            .navigationTitle("My Orders")
        }
    }
}
#Preview {
    OrdersView()
}
