//
//  ProfileView.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-08-01.
//

import SwiftUI
import SwiftUI
import FirebaseAuth

struct ProfleView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var editedName: String = ""
    @State private var showingSaved = false

    var body: some View {
        NavigationStack {
            List {
                if let u = authViewModel.user {
                    Section {
                        HStack(spacing: 16) {
                            avatarView
                            VStack(alignment: .leading, spacing: 4) {
                                Text(currentName(u))
                                    .font(.headline)
                                Text(u.email)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    Section("Edit profile") {
                        TextField("Your name", text: $editedName)
                            .textInputAutocapitalization(.words)

                        Button {
                            authViewModel.updateName(to: editedName) { err in
                                if err == nil {
                                    withAnimation { showingSaved = true }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        withAnimation { showingSaved = false }
                                    }
                                }
                            }
                        } label: {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                Text("Save")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(authViewModel.isLoading || !canSave)

                        if let err = authViewModel.authError {
                            Text(err.localizedDescription)
                                .font(.footnote)
                                .foregroundStyle(.red)
                        }
                    }

                    Section("Account") {
                        HStack {
                            Text("User ID"); Spacer()
                            Text(u.id).lineLimit(1).truncationMode(.middle)
                        }
                        HStack {
                            Text("Provider"); Spacer()
                            Text(providerLabel())
                        }
                        Button(role: .destructive) {
                            authViewModel.signOut()
                        } label: {
                            Text("Sign Out").frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                } else {
                    Section {
                        Text("You’re signed out. Please sign in to manage your profile.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                if showingSaved {
                    ToolbarItem(placement: .topBarTrailing) {
                        Label("Saved", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
            .onAppear {
                if let u = authViewModel.user {
                    editedName = currentName(u)
                }
            }
            .onChange(of: authViewModel.user?.name) { _, newVal in
                if let name = newVal { editedName = name }
            }
        }
    }

    // MARK: - Helpers

    private func currentName(_ u: User) -> String {
        if !u.name.isEmpty { return u.name }
        return Auth.auth().currentUser?.displayName ?? "User"
    }

    private var canSave: Bool {
        guard let u = authViewModel.user else { return false }
        let trimmed = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed != currentName(u)
    }

    private func providerLabel() -> String {
        let id = Auth.auth().currentUser?.providerData.first?.providerID ?? "password"
        switch id {
        case "google.com": return "Google"
        case "apple.com":  return "Apple"
        default:           return "Email/Password"
        }
    }

    private var avatarView: some View {
        Group {
            if let url = Auth.auth().currentUser?.photoURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty: ProgressView()
                    case .success(let img): img.resizable().scaledToFill()
                    case .failure: placeholderAvatar
                    @unknown default: placeholderAvatar
                    }
                }
            } else {
                placeholderAvatar
            }
        }
        .frame(width: 60, height: 60)
        .clipShape(Circle())
    }

    private var placeholderAvatar: some View {
        ZStack {
            Circle().fill(.gray.opacity(0.2))
            Image(systemName: "person.fill")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        Profle_Screen()
            .environmentObject(AuthViewModel())
    }
}
