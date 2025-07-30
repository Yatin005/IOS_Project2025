//
//  CakeViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//
import Foundation
import FirebaseFirestore

class CakeViewModel: ObservableObject {
    @Published var cakes: [Cake] = []
    @Published var isLoading = false
    @Published var error: Error?

    func fetchCakes(for albumID: String) {
        isLoading = true
        error = nil
        Firestore.firestore().collection("cakes").whereField("category", isEqualTo: albumID).getDocuments { [weak self] snapshot, err in
            self?.isLoading = false
            if let err = err {
                self?.error = err
                return
            }
            self?.cakes = snapshot?.documents.compactMap {
                try? $0.data(as: Cake.self)
            } ?? []
        }
    }
}
