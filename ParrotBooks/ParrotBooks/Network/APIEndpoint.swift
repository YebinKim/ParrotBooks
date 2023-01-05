//
//  APIEndpoint.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import Foundation

enum APIEndpoint {
    
    case search(name: String, page: Int?)
    case detail(isbn13: String)
    
    static let baseUrl: String = "https://api.itbook.store/1.0/"
    
    var url: URL {
        return URL(string: "\(APIEndpoint.baseUrl)\(path)")!
    }
    
    var method: String {
        switch self {
        case .search, .detail:
            return "GET"
        }
    }
    
    private var path: String {
        switch self {
        case .search(let name, let page):
            if let page {
                return "/search/\(name)/\(page)"
            } else {
                return "/search/\(name)"
            }
        case .detail(let isbn13):
            return "/books/\(isbn13)"
        }
    }
}
