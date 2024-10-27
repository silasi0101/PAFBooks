//
//  PAFBooksView.swift
//  PAFBooks
//
//  Created by silasi on 27/10/24.
//

import Foundation
import SwiftUI

struct PAFBooksGridView: View {
    @StateObject private var viewModel = PAFBookViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 3), spacing: 5) {
                    ForEach(viewModel.books) { book in
                        PAFImageView(thumbnail: book.thumbnail)
                    }
                }
                .padding()
            }
            .navigationTitle("Books")
        }
        .onAppear {
            viewModel.fetchBooks()
        }
    }
}

struct PAFImageView: View {
    let thumbnail: PAFBook.PAFThumbnail
    @State private var image: UIImage?
    
    var body: some View {
        let imageUrl = "\(thumbnail.domain)/\(thumbnail.basePath)/0/\(thumbnail.key)"
        let imageLoader = PAFImageLoader.shared // Use the shared instance
        
        Image(uiImage: image ?? UIImage())
            .resizable()
            .scaledToFill()
            .frame(height: 100)
            .background(Color.random().opacity(0.05))
            .cornerRadius(6)
            .shadow(radius: 3)
            .border(Color.gray, width: 1)
            .clipped()
            .onAppear {
                imageLoader.loadImage(from: imageUrl) { loadedImage in
                    DispatchQueue.main.async {
                        self.image = loadedImage
                    }
                }
            }
            .onDisappear {
                imageLoader.cancelImageLoading(for: imageUrl)
            }
    }
}

extension Color {
    static func random() -> Color {
        let colors: [Color] = [.black, .blue, .brown, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .purple, .red, .teal, .yellow]
        return colors.randomElement() ?? .gray
    }
}
