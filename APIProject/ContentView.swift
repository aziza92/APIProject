//
//  ContentView.swift
//  APIProject
//
//  Created by KARMANI Aziza on 19/09/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
  
    @State private var products: [Product] = []
    
    private func fetchData() {
        // Parse URL
        guard let url = URL(string: "https://api.spoonacular.com/food/products/search?query=yogurt&apiKey=(your API key)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    // Parse JSON
                    let decodedData = try JSONDecoder().decode(ProductResponse.self, from: data)
                    self.products = decodedData.products // Mettez à jour vos données avec les produits
                 
                } catch {
                    // Print JSON decoding error
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else if let error = error {
                // Print API call error
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    var body: some View {
      
        List(products, id: \.id) { product in
                VStack {
                    Text(product.title)
                        .font(.system(size: 14, weight: .bold))
                        .frame(maxWidth: .infinity , alignment: .center)
                        .foregroundColor(.black.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                    
                    if let imageUrl = URL(string: product.image) {
                        AsyncImage(url: imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    
                                
                            case .failure:
                                Image(systemName: "xmark")
                                    .font(.body)
                                    .bold()
                                    .foregroundColor(.black.opacity(0.5))
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .background(.gray.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                 
                            @unknown default:
                                Text("Unknown image loading state")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(.white.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.5), radius: 20)
                
            }
        .listStyle(.inset)
        .onAppear {
            fetchData()
        }

        
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Post: Codable, Identifiable , Hashable{
    let id: Int
    let title: String
    let body: String
}
struct ProductResponse: Codable {
    let type: String
    let products: [Product]
    let offset: Int
    let number: Int
    let totalProducts: Int
    let processingTimeMs: Int
}

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
}
