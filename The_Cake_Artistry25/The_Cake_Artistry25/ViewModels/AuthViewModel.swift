//
//  AuthViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//

import Foundation

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    init() {
        checkCurrentUser()
    }
    
    private func checkCurrentUser() {
        if let firebaseUser = Auth.auth().currentUser {
            self.user = User(
                uid: firebaseUser.uid,
                email: firebaseUser.email ?? "",
                name: firebaseUser.displayName ?? ""
            )
        }
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            if let firebaseUser = result?.user {
                self?.user = User(
                    uid: firebaseUser.uid,
                    email: firebaseUser.email ?? "",
                    name: firebaseUser.displayName ?? ""
                )
            }
        }
    }
    
    func signUp(name: String, email: String, password: String) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            if let firebaseUser = result?.user {
                let changeRequest = firebaseUser.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if error == nil {
                        self?.user = User(
                            uid: firebaseUser.uid,
                            email: firebaseUser.email ?? "",
                            name: name
                        )
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
