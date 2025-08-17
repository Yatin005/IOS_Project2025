//
//  CakeListView.swift
//  The_Cake_Artistry25
//
//  Created by Deep Kaleka on 2025-08-01.
//
import SwiftUI

// This is the main view that displays a grid of cake cards.
struct CakeListView: View {
    var album: Album
    @StateObject var viewModel = CakeViewModel()

    // Define the grid layout for two flexible columns.
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            // Display a loading indicator, error message, or the cake grid.
            if viewModel.isLoading {
                ProgressView("Loading Cakes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.cakes) { cake in
                        NavigationLink(destination: CakeDetailView(cake: cake)) {
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
            // Fetch cakes for the album when the view appears.
            if let albumID = album.id {
                viewModel.fetchCakes(for: albumID)
            }
        }
    }
}

// A custom view for each cake item in the grid, with a consistent layout.
struct CakeCardView: View {
    var cake: Cake

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image container with a fixed aspect ratio and fill mode.
            ZStack {
                // A solid color placeholder to prevent visual jumping while loading.
                Color(.systemGray5)

                // The AsyncImage loads the cake image from the URL.
                AsyncImage(url: URL(string: cake.imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    // Show a progress view inside a consistent frame.
                    ProgressView()
                }
            }
            .frame(height: 150)
            .clipped()
            .cornerRadius(15)

            // Cake name and price are aligned to the leading edge.
            Text(cake.name)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(2) // Prevents long names from breaking the layout
                .minimumScaleFactor(0.8) // Shrinks text if needed

            Text("$\(cake.price, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
