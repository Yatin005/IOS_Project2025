//
//  Gallery_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//

import SwiftUI


struct Gallery_Screen: View {
    @StateObject private var cakeVM = CakeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Picker("Category", selection: $cakeVM.selectedCategory) {
                    ForEach(cakeVM.categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                    ForEach(cakeVM.filteredCakes) { cake in
                        NavigationLink {
                            CakeDetail_Screen(cake: cake)
                        } label: {
                            CakeCardView(cake: cake)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("🎂 Cake Gallery")
            .overlay {
                if cakeVM.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct CakeCardView: View {
    let cake: Cake
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: cake.imageURL)) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(10)
            
            Text(cake.name)
                .font(.headline)
            
            Text("$\(cake.price, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    Gallery_Screen()
}
