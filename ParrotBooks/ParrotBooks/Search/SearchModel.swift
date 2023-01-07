//
//  SearchModel.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

struct SearchModel: Hashable {
    
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let imageUrl: String
    let storeUrl: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: SearchModel, rhs: SearchModel) -> Bool {
        lhs.title == rhs.title
    }
    
    static func convert(from book: SearchedBook.Book) -> SearchModel {
        let searchModel = SearchModel(
            title: book.title,
            subtitle: book.subtitle ?? "",
            isbn13: book.isbn13,
            price: book.price,
            imageUrl: book.imageUrl,
            storeUrl: book.storeUrl
        )
        return searchModel
    }
}
