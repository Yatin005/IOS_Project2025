//
//  Login_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct Login_Screen: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showSignup = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Login").font(.largeTitle).bold()

            TextField("Email", text: $email).autocapitalization(.none).padding().background(Color.gray.opacity(0.1)).cornerRadius(8)
            SecureField("Password", text: $password).padding().background(Color.gray.opacity(0.1)).cornerRadius(8)

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage).foregroundColor(.red)
            }

            Button("Login") {
                viewModel.login(email: email, password: password)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Button("Don't have an account? Sign Up") {
                showSignup.toggle()
            }
            .padding()

            NavigationLink("", destination: Signup_Screen(viewModel: viewModel), isActive: $showSignup).hidden()
        }
        .padding()
    }
}
