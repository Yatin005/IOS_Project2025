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
    
    // Simulating a database to store user details like name
    private var mockDatabase: [String: String] = [:]
    
    // MARK: - Initializer
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, firebaseUser in
            if let firebaseUser = firebaseUser {
                // When a user is found, fetch their details from our mock database
                self?.fetchUserDetails(for: firebaseUser.uid)
            } else {
                // If there's no user, clear the user property
                self?.user = nil
            }
        }
    }

    // MARK: - Helper Functions
    /// Simulates fetching a user's name from a database.
    /// In a real app, this would be a call to Firestore or another database.
    private func fetchUserDetails(for userId: String) {
        guard let firebaseUser = Auth.auth().currentUser else { return }
        
        // Use a mock database to get the user's name
        let name = mockDatabase[userId] ?? "Unnamed User"
        self.user = User(id: firebaseUser.uid, email: firebaseUser.email ?? "", name: name)
    }

    // MARK: - Public Authentication Functions
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
            
            // On successful signup, save the name to our mock database
            self?.mockDatabase[firebaseUser.uid] = name
            
            // Now that we have all the info, create the user object
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
            
            // On successful sign-in, we must fetch the user's details to get their name
            self?.fetchUserDetails(for: firebaseUser.uid)
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
