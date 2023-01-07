//
//  ImageLoader.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

actor ImageLoader {
    
    static let cacheMemory = NSCache<NSString, UIImage>()
    
    private let fileManager = FileManager()
    private let diskPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    
    func fetch(_ url: URL) async throws -> UIImage {
        if let cacheKey = url.absoluteString.isbn13InUrl,
           let memoryCachedImage = cacheFromMemory(key: cacheKey) {
            return memoryCachedImage
        }
        
        if let cacheKey = url.absoluteString.isbn13InUrl,
           let diskCachedImage = cacheFromDisk(key: cacheKey) {
            return diskCachedImage
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
    
    private func cacheToMemory(image: UIImage, key: String) {
        ImageLoader.cacheMemory.setObject(image, forKey: key as NSString)
    }
    
    private func cacheFromDisk(key: String) -> UIImage? {
        guard let path = diskPath else { return nil }
        
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(key)
        
        if fileManager.fileExists(atPath: filePath.path),
           let imageData = try? Data(contentsOf: filePath) {
            let image = UIImage(data: imageData)
            return image
        } else {
            return nil
        }
    }
    
    private func cacheToDisk(image: UIImage, key: String) {
        guard let path = diskPath else { return }
        
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(key)
        
        fileManager.createFile(atPath: filePath.path, contents: image.pngData())
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
            cacheToMemory(image: image, key: cacheKey)
            cacheToDisk(image: image, key: cacheKey)
        }
        
        return image
    }
}
