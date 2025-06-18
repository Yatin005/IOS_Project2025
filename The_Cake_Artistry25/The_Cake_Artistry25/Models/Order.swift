//
//  Order.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//

import Foundation
struct Order: Identifiable {
    let id: String
    let cake: Cake
    let quantity: Int
    let customerId: String
    let deliveryDate: Date
    let status: String
}
