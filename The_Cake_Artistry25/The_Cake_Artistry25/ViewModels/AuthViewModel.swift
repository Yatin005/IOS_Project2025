//
//  AuthViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//
import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var errorMessage = ""

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoggedIn = false
                } else {
                    self.isLoggedIn = true
                }
            }
        }
    }

    func signup(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.isLoggedIn = false
                } else {
                    self.isLoggedIn = true
                }
            }
        }
    }

    func logout() {
        try? Auth.auth().signOut()
        isLoggedIn = false
    }
}
