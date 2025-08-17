//
//  AlbumListView.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-08-01.
//
import SwiftUI
import SDWebImageSwiftUI // Add this line to import the new package

struct AlbumListView: View {
    @StateObject var viewModel = AlbumViewModel()
    
    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.albums) { album in
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
            
            WebImage(url: URL(string: album.imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()
                .cornerRadius(15)
            
            Text(album.title)
                .font(.headline)
                .padding(.top, 5)
        }
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
