//
//  Signup_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//
import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 16) {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if authVM.isLoading {
                ProgressView()
            } else {
                Button("Sign Up") {
                    authVM.signUp(email: email, password: password, name: name)
                }
                .buttonStyle(.borderedProminent)
            }
            
            if let error = authVM.authError {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .navigationTitle("Sign Up")
    }
}
