//
//  AuthViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//
import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var authError: Error?
    @Published var isLoading = false
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let firebaseUser = user {
                self.user = User(id: firebaseUser.uid, email: firebaseUser.email ?? "", name: "")
            } else {
                self.user = nil
            }
        }
    }

    func signUp(email: String, password: String, name: String) {
        isLoading = true
        authError = nil
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            if let error = error {
                self?.authError = error
                return
            }
            guard let firebaseUser = result?.user else { return }
            self?.user = User(id: firebaseUser.uid, email: email, name: name)
        }
    }

    func signIn(email: String, password: String) {
        isLoading = true
        authError = nil
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            if let error = error {
                self?.authError = error
                return
            }
            guard let firebaseUser = result?.user else { return }
            self?.user = User(id: firebaseUser.uid, email: firebaseUser.email ?? "", name: "")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            self.authError = signOutError
        }
    }
}
