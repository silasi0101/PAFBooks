//
//  PAFImageLoader.swift
//  PAFBooks
//
//  Created by silasi on 27/10/24.
//

import Foundation
import UIKit

class PAFImageLoader {
    static let shared = PAFImageLoader()
    private var imageCache = NSCache<NSString, UIImage>()
    private var activeTasks: [String: URLSessionDataTask] = [:]
    
    private var diskCacheDirectory: URL {
        let fileManager = FileManager.default
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cachesDirectory.appendingPathComponent("ImageCache")
    }
    
    init() {
        imageCache.countLimit = 100
        try? FileManager.default.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        cancelImageLoading(for: urlString)
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        if let image = loadImageFromDisk(urlString: urlString) {
            imageCache.setObject(image, forKey: urlString as NSString)
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            defer { self.activeTasks[urlString] = nil }
            
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self.imageCache.setObject(image, forKey: urlString as NSString)
            self.saveImageToDisk(image: image, urlString: urlString)
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        activeTasks[urlString] = task
        task.resume()
    }
    
    func cancelImageLoading(for urlString: String) {
        if let task = activeTasks[urlString] {
            task.cancel()
            activeTasks[urlString] = nil
        }
    }
    
    private func saveImageToDisk(image: UIImage, urlString: String) {
        guard let data = image.pngData() else { return }
        let fileURL = diskCacheDirectory.appendingPathComponent(urlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "image")
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving image to disk: \(error)")
        }
    }
    
    private func loadImageFromDisk(urlString: String) -> UIImage? {
        let fileURL = diskCacheDirectory.appendingPathComponent(urlString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "image")
        return UIImage(contentsOfFile: fileURL.path)
    }
}
