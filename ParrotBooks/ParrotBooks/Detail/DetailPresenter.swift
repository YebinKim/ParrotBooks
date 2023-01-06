//
//  DetailPresenter.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

protocol DetailViewPresenter {
    init(isbn13: String)
}

final class DetailPresenter: DetailViewPresenter {
    
    weak var view: DetailViewController?
    private let isbn13: String
    
    init(isbn13: String) {
        self.isbn13 = isbn13
    }
    
    func fetchDetailBook() {
        SessionManager().detailBook(isbn13: self.isbn13) { response in
            switch response.result {
            case .success(let detailedBook):
                DispatchQueue.main.async {
                    self.view?.configureView(detailedBook: detailedBook)
                }
            case .failure(let error):
                #if DEBUG
                print("[detail] detailBook error: \(error)")
                #endif
            }
        }
    }
}
