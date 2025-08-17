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
            Image("auth-image")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(.bottom, 20)

            Picker("Auth Mode", selection: $isLoginMode) {
                Text("Sign In").tag(true)
                Text("Sign Up").tag(false)
            }
            .pickerStyle(.segmented)
            .padding()

            VStack(spacing: 16) {
                if !isLoginMode {
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .textInputAutocapitalization(.words)
                }

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                Button {
                    if isLoginMode {
                        authViewModel.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                                             password: password)
                    } else {
                        authViewModel.signUp(email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                                             password: password,
                                             name: name.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                } label: {
                    Text(isLoginMode ? "Sign In" : "Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                .disabled(authViewModel.isLoading)

                // --- Google Sign-In button ---
                Button {
                    authViewModel.signInWithGoogle()
                } label: {
                    HStack(spacing: 8) {
                        // simple glyph; swap for GoogleSignInSwift's branded button if you prefer
                        Image(systemName: "g.circle")
                            .imageScale(.large)
                        Text("Continue with Google")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .disabled(authViewModel.isLoading)

                if authViewModel.isLoading {
                    ProgressView().padding(.top, 4)
                }
            }
            .padding()

            if let error = authViewModel.authError {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 4)
            }
        }
        .navigationTitle(isLoginMode ? "Sign In" : "Sign Up")
        .animation(.easeInOut, value: isLoginMode)
    }
}

#Preview {
    // Provide the environment object in previews to avoid a crash
    AuthView()
        .environmentObject(AuthViewModel())
}
