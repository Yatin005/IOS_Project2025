//
//  OrdersView.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-08-01.
//

import SwiftUI

struct OrdersView: View {
    
    var body: some View {
        NavigationView {
            List {
               
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
