//
//  AuthView.swift
//  The_Cake_Artistry25
//
//  Created by yatin on 2025-08-01.
//

import SwiftUI

struct AuthView: View {
    @State private var isLoginMode = true
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Image("auth-image") // Add a suitable image asset
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(.bottom, 20)
            
            Picker("Auth Mode", selection: $isLoginMode) {
                Text("Sign In").tag(true)
                Text("Sign Up").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            VStack(spacing: 20) {
                if !isLoginMode {
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.words)
                }

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                if authViewModel.isLoading {
                    ProgressView()
                } else {
                    Button(action: {
                        if isLoginMode {
                            authViewModel.signIn(email: email, password: password)
                        } else {
                            authViewModel.signUp(email: email, password: password, name: name)
                        }
                    }) {
                        Text(isLoginMode ? "Sign In" : "Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            
            if let error = authViewModel.authError {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .padding(.top)
            }
        }
        .navigationTitle(isLoginMode ? "Sign In" : "Sign Up")
    }
}

#Preview {
    AuthView()
}
