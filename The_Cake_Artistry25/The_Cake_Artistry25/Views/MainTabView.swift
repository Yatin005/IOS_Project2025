//
//  MainTabView.swift
//  The_Cake_Artistry25
//

import SwiftUI

private enum AppTheme {
    static let accent = Color.pink
    static let gradient = LinearGradient(
        colors: [.pink.opacity(0.9), .purple.opacity(0.9), .blue.opacity(0.9)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}

struct MainTabView: View {
    @State private var selection = 0

    init() {
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = .clear

        let selectedColor = UIColor(AppTheme.accent)
        let normalColor = UIColor.secondaryLabel

        // Selected
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        appearance.inlineLayoutAppearance.selected.iconColor = selectedColor
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        appearance.compactInlineLayoutAppearance.selected.iconColor = selectedColor
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]

        // Unselected
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
        appearance.inlineLayoutAppearance.normal.iconColor = normalColor
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
        appearance.compactInlineLayoutAppearance.normal.iconColor = normalColor
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        ZStack {
            // Same gradient backdrop everywhere
            AppTheme.gradient.ignoresSafeArea()

            TabView(selection: $selection) {
                AlbumListView()
                    .tabItem { Label("Home", systemImage: "house.fill") }
                    .tag(0)

                MyOrdersScreen()
                    .tabItem { Label("Orders", systemImage: "list.bullet.rectangle") }
                    .tag(1)

                Profle_Screen()
                    .tabItem { Label("Profile", systemImage: "person.fill") }
                    .tag(2)
            }
            
            .tint(AppTheme.accent)
            
            .toolbarBackground(AppTheme.gradient, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel()) // if subviews expect it
}
