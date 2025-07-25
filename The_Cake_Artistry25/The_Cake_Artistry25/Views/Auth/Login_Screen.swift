//
//  Login_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//


import SwiftUI

struct Login_Screen: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showSignup = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Login").font(.largeTitle).bold()

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Login") {
                viewModel.login()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("Don't have an account? Sign up") {
                showSignup.toggle()
            }
            .sheet(isPresented: $showSignup) {
                Signup_Screen(viewModel: viewModel)
            }
        }
        .padding()
    }
}
