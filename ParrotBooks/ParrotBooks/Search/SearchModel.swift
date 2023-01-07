//
//  SearchModel.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

struct SearchInfoModel: Hashable {
    
    var searchedText: String = ""
    
    var totalCount: Int = 0
    var currentPage: Int = 1
    var lastPage: Int {
        totalCount / SearchInfoModel.paging + 1
    }
    var hasNextPage: Bool {
        lastPage > currentPage
    }
    
    static let paging: Int = 10
}

struct SearchBookModel: Hashable {
    
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let imageUrl: String
    let storeUrl: String
    
    static func convert(from book: SearchedBook.Book) -> SearchBookModel {
        let searchModel = SearchBookModel(
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
