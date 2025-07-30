//
//  Home_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
import SwiftUI

struct HomeView: View {
    @StateObject var albumVM = AlbumViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                if albumVM.isLoading {
                    ProgressView("Loading Albums...")
                } else if let error = albumVM.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                } else {
                    ForEach(albumVM.albums) { album in
                        NavigationLink(destination: GalleryScreen(album: album)) {
                            VStack {
                                AsyncImage(url: URL(string: album.imageUrl)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }.frame(height: 200)

                                Text(album.title)
                            }
                        }
                    }
                }
            }
            .onAppear { albumVM.fetchAlbums() }
            .navigationTitle("Cake Albums")
        }
    }
}
