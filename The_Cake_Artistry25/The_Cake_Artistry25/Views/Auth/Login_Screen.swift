//
//  Login_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI

struct Login_Screen: View {
    @StateObject private var authVM = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("🔐 Login")
                    .font(.largeTitle)
                
                if authVM.isLoading {
                    ProgressView()
                }
                
                if let error = authVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Login") {
                    authVM.signIn(email: email, password: password)
                }
                .buttonStyle(.borderedProminent)
                .disabled(authVM.isLoading)
                
                NavigationLink("New user? Sign Up", destination: Signup_Screen())
                    .foregroundColor(.blue)
            }
            .padding()
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    Login_Screen()
}
