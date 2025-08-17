// The_Cake_Artistry25App.swift
// The_Cake_Artistry25
//
// Created by Yatin Parulkar on 2025-06-13.// The_Cake_Artistry25App.swift
import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct The_Cake_Artistry25App: App {

    init() {
        // 1) Firebase
        FirebaseApp.configure()

        // 2) Tell GoogleSignIn your client ID from Firebase
        if let clientID = FirebaseApp.app()?.options.clientID {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        } else {
            assertionFailure("Missing Firebase clientID")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel())     // make sure your VM is injected
                // 3) Handle the OAuth redirect with pure SwiftUI
                .onOpenURL { url in
                    _ = GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
