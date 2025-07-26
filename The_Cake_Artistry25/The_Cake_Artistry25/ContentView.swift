//
//  ContentView.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI
import SwiftUI

struct ContentView: View {
    @StateObject var authVM = AuthViewModel()

    var body: some View {
        NavigationView {
            if authVM.isLoggedIn {
                HomeScreen()
            } else {
                Login_Screen(viewModel: authVM)
            }
        }
    }
}


#Preview {
    ContentView()
}

