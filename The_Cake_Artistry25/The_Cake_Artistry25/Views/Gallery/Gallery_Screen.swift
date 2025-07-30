//
//  Gallery_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
import SwiftUI

struct GalleryScreen: View {
    var album: Album
    @StateObject var cakeVM = CakeViewModel()

    var body: some View {
        ScrollView {
            if cakeVM.isLoading {
                ProgressView("Loading Cakes...")
            } else if let error = cakeVM.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else {
                ForEach(cakeVM.cakes) { cake in
                    NavigationLink(destination: CustomizationScreen(cake: cake)) {
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: cake.imageUrl)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }.frame(height: 150)

                            Text(cake.name)
                            Text("$\(cake.price, specifier: "%.2f")")
                        }
                    }
                }
            }
        }
        .onAppear { cakeVM.fetchCakes(for: album.id) }
        .navigationTitle(album.title)
    }
}
