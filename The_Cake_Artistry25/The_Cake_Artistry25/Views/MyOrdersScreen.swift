//
//  MyOrdersScreen.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-08-01.
//

import SwiftUI
import FirebaseFirestore
import MapKit

struct MyOrdersScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var orderVM = OrderViewModel()
    @StateObject var locationManager = LocationManager()
    @State private var cakeNames: [String: String] = [:] // cache cakeID -> name
    @State private var copiedOrderId: String?

    // Formatters
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }
    private let relativeFormatter: RelativeDateTimeFormatter = {
        let r = RelativeDateTimeFormatter()
        r.unitsStyle = .short
        return r
    }()

    var body: some View {
        NavigationStack {
            ZStack {
                // ❌ Removed themed gradient background

                ScrollView {
                    VStack(spacing: 12) {
                        header

                        if let statusMessage = locationManager.regionStatusMessage, !statusMessage.isEmpty {
                            statusBanner(statusMessage)
                                .padding(.horizontal, 16)
                        }

                        if orderVM.orders.isEmpty {
                            emptyState
                                .padding(.top, 24)
                        } else {
                            LazyVStack(spacing: 14) {
                                ForEach(orderVM.orders) { order in
                                    OrderCard(
                                        order: order,
                                        cakeName: cakeNames[order.cakeID],
                                        dateText: dateFormatter.string(from: order.timestamp),
                                        relativeText: relativeFormatter.localizedString(for: order.timestamp, relativeTo: Date()),
                                        onTrack: {},
                                        onCopyId: {
                                            if let id = order.id {
                                                UIPasteboard.general.string = id
                                                withAnimation(.spring) { copiedOrderId = id }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                                    withAnimation(.easeOut) { copiedOrderId = nil }
                                                }
                                            }
                                        }
                                    )
                                    .onAppear {
                                        if cakeNames[order.cakeID] == nil {
                                            fetchCakeName(for: order.cakeID)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(.bottom, 24)
                }
                .background(Color(.systemBackground)) // ✅ standard system background
                .refreshable {
                    if let userID = authViewModel.user?.id {
                        orderVM.fetchOrders(for: userID)
                    }
                }

                if copiedOrderId != nil {
                    toast("Order ID copied")
                }
            }
            .navigationTitle("My Orders")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if let userID = authViewModel.user?.id {
                    orderVM.fetchOrders(for: userID)
                }
            }
            .onChange(of: authViewModel.user?.id) { _, newID in
                if let id = newID {
                    orderVM.fetchOrders(for: id)
                } else {
                    orderVM.orders = []
                }
            }
        }
    }

    // MARK: - UI Sections

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "bag.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.pink)
                .padding(10)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 2) {
                Text("Order history")
                    .font(.title2.bold())
                Text("Track and review your past orders")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private func statusBanner(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "mappin.and.ellipse")
            Text(text).lineLimit(2)
            Spacer()
        }
        .font(.footnote)
        .padding(12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.15)))
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "cart.badge.plus")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No orders yet")
                .font(.headline)
            Text("Your orders will show up here once you place one.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.12)))
        .padding(.horizontal, 16)
    }

    private func toast(_ text: String) -> some View {
        Text(text)
            .font(.footnote.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.25)))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 26)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: - Firestore helper

    private func fetchCakeName(for cakeID: String) {
        let db = Firestore.firestore()
        db.collection("cakes").document(cakeID).getDocument { (document, error) in
            guard error == nil, let document = document, document.exists,
                  let cakeName = document.data()?["name"] as? String else {
                print("Cake name fetch failed for \(cakeID): \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                cakeNames[cakeID] = cakeName
            }
        }
    }
}

// MARK: - Order Card

private struct OrderCard: View {
    let order: Order
    let cakeName: String?
    let dateText: String
    let relativeText: String
    var onTrack: () -> Void
    var onCopyId: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(cakeName ?? "Fetching…")
                    .font(.headline)
                    .lineLimit(2)
                Spacer()
                priceBadge
            }

            HStack(spacing: 8) {
                chip(text: "Flavour: \(order.flavor)", systemImage: "fork.knife")
                chip(text: "Qty: \(order.quantity)", systemImage: "number.circle")
            }

            if let address = order.address, !address.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "house.fill")
                        .foregroundStyle(.secondary)
                    Text(address)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }
            }

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
                Text(dateText)
                    .font(.subheadline)
                Spacer()
                Text(relativeText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            // Actions
            HStack {
                if let id = order.id, !id.isEmpty {
                    NavigationLink {
                        OrderTrackingView(orderId: id)
                    } label: {
                        Label("Track this order", systemImage: "map.fill")
                            .font(.subheadline.weight(.semibold))
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer(minLength: 8)

                    Button {
                        onCopyId()
                    } label: {
                        Label("Copy ID", systemImage: "doc.on.doc")
                            .font(.subheadline.weight(.semibold))
                    }
                    .buttonStyle(.bordered)
                } else {
                    Text("Order ID unavailable")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, 2)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.12))
        )
        .shadow(color: .black.opacity(0.08), radius: 10, y: 6)
    }

    private var priceBadge: some View {
        Text(String(format: "$%.2f", order.totalPrice))
            .font(.subheadline.weight(.bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(Color.pink.opacity(0.18))
            )
    }

    private func chip(text: String, systemImage: String) -> some View {
        Label {
            Text(text).font(.footnote)
        } icon: {
            Image(systemName: systemImage)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(.thinMaterial))
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        MyOrdersScreen()
            .environmentObject(AuthViewModel())
    }
}
