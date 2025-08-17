//
//  Welcome_Screen.swift
//  The_Cake_Artistry25
//
//  Created by Yatin Parulkar on 2025-06-13.
//
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("app-logo") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 20)

                Text("The Cake Artistry")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Where every cake is a masterpiece.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 50)

                NavigationLink(destination: AuthView()) {
                    Text("Get Started")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}
#Preview {
    
}
