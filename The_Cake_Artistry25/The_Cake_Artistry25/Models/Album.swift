// Album.swift
import Foundation
import FirebaseFirestore

struct Album: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var imageUrl: String
}
