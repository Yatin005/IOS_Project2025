//
//  Home_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
// HomeView.swift
import SwiftUI

struct Home_Screen: View {
    @StateObject private var albumVM = AlbumViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if albumVM.isLoading {
                    ProgressView("Loading Albums...")
                        .padding()
                } else if let error = albumVM.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if albumVM.albums.isEmpty {
                    Text("No albums available.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    LazyVStack(spacing: 20) {
                        ForEach(albumVM.albums) { album in
                            NavigationLink(destination: Text(album.title)) {
                                VStack {
                                    AsyncImage(url: URL(string: album.imageUrl)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(height: 200)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    
                                    Text(album.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Cake Albums")
            .onAppear {
                albumVM.fetchAlbums()
            }
        }
    }
}
