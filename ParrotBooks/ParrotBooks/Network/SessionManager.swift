//
//  SessionManager.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import Foundation

final class SessionManager {
    
    private let session: URLSessionProtocol
    private var dataTask: URLSessionDataTaskProtocol?
    
    init(
        session: URLSessionProtocol = URLSession.shared
    ) {
        self.session = session
    }
    
    func searchBook(
        name: String,
        page: Int? = nil,
        completion: @escaping (APIResponse<SearchBookModel>) -> Void
    ) {
        
        dataTask?.cancel()
        
        let endpoint = APIEndpoint.search(name: name, page: page)
        let url = endpoint.url
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let response = response as? HTTPURLResponse {
                let apiResponse = APIResponse<SearchBookModel>(data: data, response: response, error: error as? APIError)
                completion(apiResponse)
            } else {
                let apiResponse = APIResponse<SearchBookModel>(data: nil, response: nil, error: error as? APIError)
                completion(apiResponse)
            }
        }
        
        dataTask?.resume()
    }
    
    func detailBook(
        isbn13: String,
        completion: @escaping (APIResponse<DetailedBook>) -> Void
    ) {
        
        dataTask?.cancel()
        
        let endpoint = APIEndpoint.detail(isbn13: isbn13)
        let url = endpoint.url
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let response = response as? HTTPURLResponse {
                let apiResponse = APIResponse<DetailedBook>(data: data, response: response, error: error as? APIError)
                completion(apiResponse)
            } else {
                let apiResponse = APIResponse<DetailedBook>(data: nil, response: nil, error: error as? APIError)
                completion(apiResponse)
            }
        }
        
        dataTask?.resume()
    }
}
