//
//  CakeDetail_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
import SwiftUI

struct CakeDetail_Screen: View {
    let cake: Cake
    @State private var quantity = 1
    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: cake.imageURL)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(15)
                .shadow(radius: 5)
                
                Text(cake.name)
                    .font(.largeTitle)
                
                Text(cake.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Price:")
                    Text("$\(cake.price, specifier: "%.2f")")
                        .font(.title2)
                        .bold()
                }
                
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                
                DatePicker("Delivery Date", selection: $selectedDate, in: Date()...)
                
                NavigationLink {
                    Customization_Screen(cake: cake, quantity: quantity, deliveryDate: selectedDate)
                } label: {
                    Text("Customize & Order")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
            }
            .padding()
        }
        .navigationTitle(cake.name)
    }
}

#Preview {
    CakeDetail_Screen(cake: Cake(
        id: "1",
        name: "Chocolate Cake",
        description: "Delicious chocolate cake",
        imageURL: "https://example.com/cake.jpg",
        price: 29.99,
        category: "Chocolate"
    ))
}
