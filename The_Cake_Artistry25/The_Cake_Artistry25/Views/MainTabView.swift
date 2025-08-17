//
//  MainTabView.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-08-01.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            AlbumListView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            MyOrdersScreen()
                            .tabItem {
                                Label("Orders", systemImage: "list.bullet.rectangle")
                            }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
