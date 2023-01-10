//
//  SessionManager.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import Foundation

final class SessionManager {
    
    private let session: URLSession
    
    private var searchDataTask: Task<APIResponse<SearchBookModel>, Error>?
    private var detailDataTask: Task<APIResponse<DetailBookModel>, Error>?
    
    init(
        session: URLSession = URLSession.shared
    ) {
        self.session = session
    }
    
    func searchBook(
        name: String,
        page: Int? = nil
    ) async throws -> APIResponse<SearchBookModel> {
        
        searchDataTask?.cancel()
        
        searchDataTask = Task { () -> APIResponse<SearchBookModel> in
            let endpoint = APIEndpoint.search(name: name, page: page)
            let url = endpoint.url
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method
            
            let (data, response) = try await session.data(for: request)
            try Task.checkCancellation()
            
            guard let response = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            let apiResponse = APIResponse<SearchBookModel>(data: data, response: response)
            return apiResponse
        }
        
        return try await searchDataTask!.value
    }
    
    func detailBook(
        isbn13: String
    ) async throws -> APIResponse<DetailBookModel> {
        
        detailDataTask?.cancel()
        
        detailDataTask = Task { () -> APIResponse<DetailBookModel> in
            let endpoint = APIEndpoint.detail(isbn13: isbn13)
            let url = endpoint.url
            var request = URLRequest(url: url)
            request.httpMethod = endpoint.method
            
            let (data, response) = try await session.data(for: request)
            try Task.checkCancellation()
            
            guard let response = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            let apiResponse = APIResponse<DetailBookModel>(data: data, response: response)
            return apiResponse
        }
        
        return try await detailDataTask!.value
    }
}
