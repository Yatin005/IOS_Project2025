//
//  AlbumViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-07-29.
//
//
//  AlbumViewModel.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-07-29.
//

import Foundation
import FirebaseFirestore

class AlbumViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchAlbums() {
        isLoading = true
        error = nil
        Firestore.firestore().collection("albums").getDocuments { [weak self] snapshot, err in
            guard let self = self else { return }
            self.isLoading = false
            
            if let err = err {
                self.error = err
                print("Error fetching albums: \(err.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found.")
                return
            }

            // --- DEBUGGING CODE ADDED HERE ---
            print("Found \(documents.count) documents in the 'albums' collection.")
            
            let fetchedAlbums = documents.compactMap { documentSnapshot -> Album? in
                let data = documentSnapshot.data()
                print("Attempting to decode document with data: \(data)")
                
                do {
                    // Try to decode the document into an Album object
                    let album = try documentSnapshot.data(as: Album.self)
                    print("✅ Successfully decoded album: \(album.title)")
                    return album
                } catch {
                    // If decoding fails, print the error to see why
                    print("❌ Failed to decode document with ID \(documentSnapshot.documentID) into Album. Error: \(error.localizedDescription)")
                    return nil
                }
            }
            // --- END OF DEBUGGING CODE ---
            
            if fetchedAlbums.isEmpty {
                print("Successfully connected to Firestore, but no albums were found.")
            } else {
                print("Successfully fetched \(fetchedAlbums.count) albums.")
            }
            
            self.albums = fetchedAlbums
        }
    }
}
