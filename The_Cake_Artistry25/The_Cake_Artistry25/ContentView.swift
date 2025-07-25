//
//  ContentView.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        if viewModel.isLoggedIn {
            VStack(spacing: 20) {
                Text("Welcome, \(viewModel.email)!")
                    .font(.title)
                Button("Logout") {
                    viewModel.logout()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        } else {
            Login_Screen(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}

