//
//  DetailBookModel.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import Foundation

struct DetailBookModel: Decodable {
    
    let error: String
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let language: String?
    let isbn10: String
    let isbn13: String
    let pages: String
    let year: String
    let rating: String
    let description: String
    let price: String
    let imageUrl: String
    let storeUrl: String
    let pdfUrls: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case error
        case title
        case subtitle
        case authors
        case publisher
        case language
        case isbn10
        case isbn13
        case pages
        case year
        case rating
        case description = "desc"
        case price
        case imageUrl = "image"
        case storeUrl = "url"
        case pdfUrls = "pdf"
    }
}
