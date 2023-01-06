//
//  ImageLoader.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

actor ImageLoader {
    
    func fetch(_ url: URL) async throws -> UIImage {
        let urlRequest = URLRequest(url: url)
        let task: Task<UIImage, Error> = Task {
            let (imageData, _/*response*/) = try await URLSession.shared.data(for: urlRequest)
            let image = UIImage(data: imageData)!
            return image
        }
        let image = try await task.value
        
        return image
    }
}
