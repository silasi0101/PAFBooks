//
//  PAFBooksViewModel.swift
//  PAFBooks
//
//  Created by silasi on 27/10/24.
//

import Foundation

class PAFBookViewModel: ObservableObject {
    @Published var books: [PAFBook] = []
    
    func fetchBooks() {
        guard let url = URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                print("Error fetching books: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedBooks = try JSONDecoder().decode([PAFBook].self, from: data)
                DispatchQueue.main.async {
                    self.books = decodedBooks
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
