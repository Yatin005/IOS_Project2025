//
//  Signup_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//

import Foundation

import SwiftUI

struct Signup_Screen: View {
    @StateObject private var authVM = AuthViewModel()
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("✏️ Sign Up")
                    .font(.largeTitle)
                
                if authVM.isLoading {
                    ProgressView()
                }
                
                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Create Account") {
                    authVM.signUp(name: name, email: email, password: password)
                }
                .buttonStyle(.borderedProminent)
                .disabled(authVM.isLoading)
                
                NavigationLink("Already have an account? Login", destination: Login_Screen())
                    .foregroundColor(.blue)
            }
            .padding()
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    Signup_Screen()
}
