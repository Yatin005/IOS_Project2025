//
//  AuthViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//

import Foundation
import Combine
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore    
import UIKit

/// Your app's user model is custom (id/email/name), so we keep using it.
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var authError: Error?
    @Published var isLoading = false

    
    private var mockDatabase: [String: String] = [:]

    // MARK: - Initializer
    init() {
        
        if let current = Auth.auth().currentUser {
            self.user = buildUser(from: current)
        }

        
        Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self = self else { return }
            if let firebaseUser = firebaseUser {
                self.user = self.buildUser(from: firebaseUser)
            } else {
                self.user = nil
            }
        }
    }

    // MARK: - Helpers

    private func buildUser(from firebaseUser: FirebaseAuth.User) -> User {
        
        let nameFromDB = mockDatabase[firebaseUser.uid]
        let name = nameFromDB ?? firebaseUser.displayName ?? "Unnamed User"
        let email = firebaseUser.email ?? ""
        return User(id: firebaseUser.uid, email: email, name: name)
    }

    // MARK: - Email/Password

    func signUp(email: String, password: String, name: String) {
        isLoading = true
        authError = nil

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            self.isLoading = false

            if let error = error {
                self.authError = error
                return
            }

            guard let firebaseUser = result?.user else { return }

           
            self.mockDatabase[firebaseUser.uid] = name
            let change = firebaseUser.createProfileChangeRequest()
            change.displayName = name
            change.commitChanges(completion: nil)

            Firestore.firestore()
                .collection("users").document(firebaseUser.uid)
                .setData(["name": name, "email": email], merge: true)

            self.user = self.buildUser(from: firebaseUser)
        }
    }

    func signIn(email: String, password: String) {
        isLoading = true
        authError = nil

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            self.isLoading = false

            if let error = error {
                self.authError = error
                return
            }
            guard let firebaseUser = result?.user else { return }
            self.user = self.buildUser(from: firebaseUser)
        }
    }

    // MARK: - Google Sign-In

    @MainActor
    func signInWithGoogle() {
        isLoading = true
        authError = nil

        guard let presentingVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController else {
                self.isLoading = false
                self.authError = NSError(domain: "Auth", code: -10,
                                         userInfo: [NSLocalizedDescriptionKey: "No root view controller to present Google Sign-In"])
                return
            }

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                Task { @MainActor in
                    self.isLoading = false
                    self.authError = error
                }
                return
            }

            guard
                let idToken = result?.user.idToken?.tokenString,
                let accessToken = result?.user.accessToken.tokenString
            else {
                Task { @MainActor in
                    self.isLoading = false
                    self.authError = NSError(domain: "Auth", code: -11,
                                             userInfo: [NSLocalizedDescriptionKey: "Missing Google tokens"])
                }
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                Task { @MainActor in
                    self.isLoading = false

                    if let error = error {
                        self.authError = error
                        return
                    }

                    guard let firebaseUser = authResult?.user else { return }

                  
                    if self.mockDatabase[firebaseUser.uid] == nil, let display = firebaseUser.displayName {
                        self.mockDatabase[firebaseUser.uid] = display
                    }

            
                    Firestore.firestore()
                        .collection("users").document(firebaseUser.uid)
                        .setData([
                            "name": firebaseUser.displayName ?? "",
                            "email": firebaseUser.email ?? ""
                        ], merge: true)

                    self.user = self.buildUser(from: firebaseUser)
                }
            }
        }
    }

    // MARK: - Update Name (NEW)

    @MainActor
    func updateName(to newName: String, completion: ((Error?) -> Void)? = nil) {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            let err = NSError(domain: "Auth", code: -1001,
                              userInfo: [NSLocalizedDescriptionKey: "Name cannot be empty"])
            self.authError = err
            completion?(err)
            return
        }
        guard let fbUser = Auth.auth().currentUser else {
            let err = NSError(domain: "Auth", code: -1002,
                              userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
            self.authError = err
            completion?(err)
            return
        }

        isLoading = true
        authError = nil

        let change = fbUser.createProfileChangeRequest()
        change.displayName = trimmed
        change.commitChanges { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.authError = error
                    completion?(error)
                    return
                }

             
                self.mockDatabase[fbUser.uid] = trimmed
                self.user = User(id: fbUser.uid, email: fbUser.email ?? "", name: trimmed)

                Firestore.firestore()
                    .collection("users").document(fbUser.uid)
                    .setData(["name": trimmed], merge: true) { _ in
                       
                    }

                completion?(nil)
            }
        }
    }

    // MARK: - Sign Out

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            self.authError = error
        }
    }
}
