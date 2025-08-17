//
//  CakeListView.swift
//  The_Cake_Artistry25
//
//  Created by Het Shah on 2025-08-01.
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
            
            if let albumID = album.id {
                viewModel.fetchCakes(for: albumID)
            }
        }
    }
}

struct CakeCardView: View {
    var cake: Cake

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Color(.systemGray5)
                AsyncImage(url: URL(string: cake.imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
            }
            .frame(height: 150)
            .clipped()
            .cornerRadius(15)

            Text(cake.name)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

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
