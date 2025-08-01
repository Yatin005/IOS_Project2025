//
//  CakeListView.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-08-01.
//
import SwiftUI

struct CakeListView: View {
    var album: Album
    @StateObject var viewModel = CakeViewModel()

     var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Loading Cakes...")
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.cakes) { cake in
                        NavigationLink(destination: CakeDetailScreen(cake: cake)) {
                            CakeCardView(cake: cake)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(album.title)
        .onAppear {
            if let albumID = album.id {
                viewModel.fetchCakes(for: albumID)
            }
        }
    }
}

// A custom view for each cake item in the grid
struct CakeCardView: View {
    var cake: Cake
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: cake.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
                    .frame(height: 150)
            }
            .frame(height: 150)
            .clipped()
            .cornerRadius(15)
            
            Text(cake.name)
                .font(.headline)
                .foregroundColor(.black)
            
            Text("$\(cake.price, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
