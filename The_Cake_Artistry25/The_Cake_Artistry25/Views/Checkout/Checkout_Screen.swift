//
//  CheckoutScreen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-08-01.
//

import SwiftUI
import CoreLocation

private enum AppTheme {
    static let accent = Color.pink
}

struct CheckoutScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var checkoutVM: CheckoutViewModel

    @StateObject private var locationManager = LocationManager()

    var cake: Cake
    var customizationText: String
    var quantity: Int
    var flavor: String
    var orderDate: Date
    var orderTime: Date

    @State private var searchQuery: String = ""
    @State private var selectedAddress: String?
    @State private var showingOrderConfirmation = false
    @FocusState private var searchFocused: Bool

    private var totalPrice: Double { cake.price * Double(quantity) }

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // ---------- Order Summary Card ----------
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(alignment: .top, spacing: 16) {
                            AsyncImage(url: URL(string: cake.imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12).fill(.thinMaterial)
                                        ProgressView()
                                    }
                                case .success(let img):
                                    img.resizable().scaledToFill()
                                case .failure:
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12).fill(.thinMaterial)
                                        Image(systemName: "photo")
                                            .foregroundStyle(.secondary)
                                    }
                                @unknown default:
                                    Color.clear
                                }
                            }
                            .frame(width: 110, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                            VStack(alignment: .leading, spacing: 6) {
                                Text(cake.name)
                                    .font(.title3.weight(.semibold))
                                    .lineLimit(2)
                                HStack(spacing: 10) {
                                    badge(text: "Qty: \(quantity)", icon: "number.circle")
                                    badge(text: flavor, icon: "fork.knife")
                                }
                                Text("Unit: $\(cake.price, specifier: "%.2f")")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }

                        Divider().opacity(0.2)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Customization").font(.headline)
                            Text(customizationText.isEmpty ? "None" : customizationText)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.12)))

                    // ---------- Delivery Address Card ----------
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Delivery Address").font(.headline)

                        if let finalAddress = selectedAddress {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "mappin.and.ellipse").foregroundStyle(AppTheme.accent)
                                Text(finalAddress)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(12)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }

                        TextField("Search for your address…", text: $searchQuery)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.words)
                            .focused($searchFocused)
                            .onChange(of: searchQuery) { newValue in
                                locationManager.search(query: newValue)
                            }

                        if !locationManager.searchResults.isEmpty {
                            VStack(spacing: 0) {
                                ForEach(locationManager.searchResults, id: \.self) { placemark in
                                    Button {
                                        selectedAddress = locationManager.formatAddress(placemark)
                                        locationManager.searchResults = []
                                        searchQuery = ""
                                        searchFocused = false
                                    } label: {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(placemark.name ?? "Unknown Place")
                                                .font(.subheadline.weight(.semibold))
                                            Text(locationManager.formatAddress(placemark))
                                                .font(.footnote)
                                                .foregroundStyle(.secondary)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(12)
                                    }
                                    .buttonStyle(.plain)

                                    if placemark != locationManager.searchResults.last {
                                        Divider().opacity(0.15)
                                    }
                                }
                            }
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.12)))

                    // ---------- Total ----------
                    HStack {
                        Text("Total Amount")
                            .font(.title3.weight(.medium))
                        Spacer()
                        Text("$\(totalPrice, specifier: "%.2f")")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.green)
                    }
                    .padding(16)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.12)))

                    // ---------- Place Order ----------
                    if checkoutVM.isProcessingOrder {
                        ProgressView("Placing Order…")
                            .progressViewStyle(.circular)
                            .tint(AppTheme.accent)
                            .padding(.top, 8)
                    } else {
                        Button {
                            guard authViewModel.user != nil else { return }
                            let addressToUse = selectedAddress
                            checkoutVM.checkout(
                                cake: cake,
                                quantity: quantity,
                                flavor: flavor,
                                orderDate: orderDate,
                                orderTime: orderTime,
                                customization: customizationText,
                                address: addressToUse
                            )
                        } label: {
                            Text("Order Now")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.accent)
                        .disabled(authViewModel.user == nil)
                        .opacity(authViewModel.user == nil ? 0.6 : 1.0)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color(.systemBackground)) // ← standard system background
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: checkoutVM.orderSuccess) { success in
            if success { showingOrderConfirmation = true }
        }
        .alert(isPresented: $showingOrderConfirmation) {
            Alert(
                title: Text("Order Placed! 🥳"),
                message: Text("Your order has been placed successfully."),
                dismissButton: .default(Text("OK")) { dismiss() }
            )
        }
        .onAppear { print("CheckoutScreen appeared with cake: \(cake.name)") }
    }

    // MARK: - Small helpers

    private func badge(text: String, icon: String) -> some View {
        Label {
            Text(text).font(.footnote)
        } icon: {
            Image(systemName: icon)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(.thinMaterial))
    }
}
