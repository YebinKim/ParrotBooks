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
    private var detailedBook: DetailedBook?
    
    init(isbn13: String) {
        self.isbn13 = isbn13
    }
    
    func fetchDetailBook() {
        SessionManager().detailBook(isbn13: self.isbn13) { response in
            switch response.result {
            case .success(let detailedBook):
                self.detailedBook = detailedBook
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
    
    func storeUrlButtonTapped() {
        guard let detailedBook else { return }
        #if DEBUG
        print("[detail] storeUrlButtonTapped with: \(detailedBook.storeUrl)")
        #endif
        
        guard let url = URL(string: detailedBook.storeUrl) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
