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
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let err = err {
                self.error = err
                print("❌ Error fetching cakes: \(err.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found for albumID: \(albumID).")
                return
            }
            
            // --- DEBUGGING CODE ADDED HERE ---
            print("Found \(documents.count) documents for albumID: \(albumID).")

            let fetchedCakes = documents.compactMap { documentSnapshot -> Cake? in
                let data = documentSnapshot.data()
                print("Attempting to decode cake with data: \(data)")
                
                do {
                    let cake = try documentSnapshot.data(as: Cake.self)
                    print("✅ Successfully decoded cake: \(cake.name)")
                    return cake
                } catch {
                    print("❌ Failed to decode cake with ID \(documentSnapshot.documentID) into Cake. Error: \(error.localizedDescription)")
                    return nil
                }
            }
            // --- END OF DEBUGGING CODE ---
            
            if fetchedCakes.isEmpty {
                print("Successfully connected, but no cakes were found for albumID: \(albumID).")
            } else {
                print("Successfully fetched \(fetchedCakes.count) cakes.")
            }
            
            self.cakes = fetchedCakes
        }
    }
}
