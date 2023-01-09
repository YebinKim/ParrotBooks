//
//  SearchBookModel.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import Foundation

struct SearchBookModel: Decodable, Hashable {
    
    let error: String
    let total: String
    let page: String?
    let books: [Book]
    
    enum CodingKeys: String, CodingKey {
        case error
        case total
        case page
        case books
    }
    
    struct Book: Decodable, Hashable {
        let title: String
        let subtitle: String?
        let isbn13: String
        let price: String
        let imageUrl: String
        let storeUrl: String
        
        enum CodingKeys: String, CodingKey {
            case title
            case subtitle
            case isbn13
            case price
            case imageUrl = "image"
            case storeUrl = "url"
        }
    }
}
