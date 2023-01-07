//
//  ImageLoader.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

actor ImageLoader {
    
    static let cacheMemory = NSCache<NSString, UIImage>()
    
    func fetch(_ url: URL) async throws -> UIImage {
        if let cacheKey = url.absoluteString.isbn13InUrl,
           let memoryCachedImage = cacheFromMemory(key: cacheKey) {
            return memoryCachedImage
        }
        
        let downloadedImage = try await downloadImage(from: url)
        
        return downloadedImage
    }
    
    private func cacheFromMemory(key: String) -> UIImage? {
        let cacheKey = NSString(string: key)
        if let cachedImage = ImageLoader.cacheMemory.object(forKey: cacheKey) {
            return cachedImage
        } else {
            return nil
        }
    }
    
    private func downloadImage(from url: URL) async throws -> UIImage {
        let urlRequest = URLRequest(url: url)
        let task: Task<UIImage, Error> = Task {
            let (imageData, _/*response*/) = try await URLSession.shared.data(for: urlRequest)
            let image = UIImage(data: imageData)!
            return image
        }
        let image = try await task.value
        
        if let cacheKey = url.absoluteString.isbn13InUrl {
            ImageLoader.cacheMemory.setObject(image, forKey: cacheKey as NSString)
        }
        
        return image
    }
}
