//
//  APIResponse.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import Foundation

enum APIError: Error {
    case unknown
    case noData
    case networking
    case decodingJSON
}

struct APIResponse<T: Decodable> {
    
    let result: Result<T, APIError>
    let statusCode: Int
    
    init(
        data: Data?,
        response: HTTPURLResponse?
    ) {
        guard let data = data,
              let statusCode = response?.statusCode else {
            self.result = .failure(APIError.noData)
            self.statusCode = -1000
            return
        }
        
        self.statusCode = statusCode
        
        switch statusCode{
        case 200..<300:
            let decoded = try? JSONDecoder().decode(T.self, from: data)
            self.result = decoded != nil ? Result.success(decoded!) : Result.failure(APIError.decodingJSON)
        case 300..<1000:
            self.result = Result.failure(APIError.networking)
        default:
            self.result = Result.failure(APIError.unknown)
        }
    }
}
