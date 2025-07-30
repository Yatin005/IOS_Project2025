//
//  AlbumViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-07-29.
//
import Foundation
import FirebaseFirestore

class AlbumViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    // AlbumViewModel.swift
    func fetchAlbums() {
        print("Fetching albums...")
        isLoading = true
        error = nil
        Firestore.firestore().collection("albums").getDocuments { [weak self] snapshot, err in
            self?.isLoading = false
            if let err = err {
                self?.error = err
                print("Error fetching albums: \(err.localizedDescription)") // Add this line
                return
            }

            let fetchedAlbums = snapshot?.documents.compactMap {
                try? $0.data(as: Album.self)
            } ?? []
            self?.albums = fetchedAlbums
            print("Successfully fetched \(fetchedAlbums.count) albums.") // Add this line
        }
    }
}
