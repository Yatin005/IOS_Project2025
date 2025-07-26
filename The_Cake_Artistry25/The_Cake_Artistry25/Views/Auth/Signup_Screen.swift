//
//  Signup_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.

import SwiftUI

struct Signup_Screen: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up").font(.largeTitle).bold()

            TextField("Email", text: $email).autocapitalization(.none).padding().background(Color.gray.opacity(0.1)).cornerRadius(8)
            SecureField("Password", text: $password).padding().background(Color.gray.opacity(0.1)).cornerRadius(8)

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage).foregroundColor(.red)
            }

            Button("Sign Up") {
                viewModel.signup(email: email, password: password)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

