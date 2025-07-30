//
//  Login_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if authVM.isLoading {
                ProgressView()
            } else {
                Button("Login") {
                    authVM.signIn(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)
            }
            
            if let error = authVM.authError {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
            
            Divider()
            
            NavigationLink("Don't have an account? Sign Up", destination: SignUpView(authVM: authVM))
        }
        .padding()
        .navigationTitle("Login")
    }
}
