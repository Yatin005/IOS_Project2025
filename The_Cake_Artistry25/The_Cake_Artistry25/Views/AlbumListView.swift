//
//  AlbumListView.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-08-01.
//
import SwiftUI

struct AlbumListView: View {
    @StateObject var viewModel = AlbumViewModel()
    
    // The columns for your grid.
    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                // Display the grid of albums
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.albums) { album in
                        // Wrap the AlbumCardView in a NavigationLink
                        NavigationLink(destination: CakeListView(album: album)) {
                            AlbumCardView(album: album)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Cake Categories")
            .onAppear {
                viewModel.fetchAlbums()
            }
        }
    }
}

// A custom view for each album item
struct AlbumCardView: View {
    var album: Album
    
    var body: some View {
        VStack {
            // Display the album image from its URL
            AsyncImage(url: URL(string: album.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill) // Fills the frame, cropping if needed
            } placeholder: {
                ProgressView()
                    .frame(width: 150, height: 150) // Placeholder also has a fixed size
            }
            .frame(height: 150)
            .clipped()
            .cornerRadius(15)
            
            // Display the album title below the image
            Text(album.title)
                .font(.headline)
                .padding(.top, 5)
        }
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
