//
//  The_Cake_Artistry25App.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI
import FirebaseCore

@main
struct The_Cake_Artistry25App: App {
    @StateObject private var authVM = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        Group {
            if authVM.user != nil {
                Home_Screen()
            } else {
                Welcome_Screen()
            }
        }
    }
}
