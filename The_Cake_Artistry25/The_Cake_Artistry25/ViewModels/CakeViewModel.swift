//
//  CakeViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-06-18.
//

import Foundation

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class CakeViewModel: ObservableObject {
    @Published var cakes: [Cake] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCategory: String = "All"
    
    private let db = Firestore.firestore()
    
    init() {
        fetchCakes()
    }
    
    func fetchCakes() {
        isLoading = true
        db.collection("cakes").getDocuments { [weak self] snapshot, error in
            self?.isLoading = false
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            
            self?.cakes = snapshot?.documents.compactMap { document in
                try? document.data(as: Cake.self)
            } ?? []
        }
    }
    
    var filteredCakes: [Cake] {
        if selectedCategory == "All" {
            return cakes
        }
        return cakes.filter { $0.category == selectedCategory }
    }
    
    var categories: [String] {
        var allCategories = ["All"]
        allCategories.append(contentsOf: Set(cakes.map { $0.category }).sorted())
        return allCategories
    }
    
    func getCake(byId id: String) -> Cake? {
        cakes.first { $0.id == id }
    }
}
