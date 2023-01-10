//
//  DetailPresenter.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit
import PDFKit

// view -> presenter
protocol DetailPresenterProtocol {
    var detailedBook: DetailBookModel? { get set }
    var isbn13: String? { get }
    
    func fetchDetailBook(with isbn13: String?) async
    
    func storeUrlButtonTapped(with urlString: String?)
    func pdfDownloadButtonTapped(_ button: UIButton)
}

final class DetailPresenter: DetailPresenterProtocol {
    
    // MARK: - View
    private weak var view: DetailViewProtocol!
    
    // MARK: - Model
    var detailedBook: DetailBookModel?
    var isbn13: String?
    
    // MARK: - Initializer
    init(
        view: DetailViewProtocol? = nil,
        isbn13: String? = nil
    ) {
        self.view = view
        self.isbn13 = isbn13
    }
    
    func fetchDetailBook(with isbn13: String?) async {
        guard let isbn13,
              let response = try? await SessionManager().detailBook(isbn13: isbn13) else {
            return
        }
        
        switch response.result {
        case .success(let detailedBook):
            self.detailedBook = detailedBook
            Task { @MainActor in
                self.view.setupView(with: detailedBook)
            }
        case .failure(let error):
            #if DEBUG
            print("[detail] detailBook error: \(error)")
            #endif
        }
    }
    
    func storeUrlButtonTapped(with urlString: String?) {
        #if DEBUG
        print("[detail] storeUrlButtonTapped with: \(urlString ?? "no url")")
        #endif
        
        guard let urlString, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:])
    }
    
    func pdfDownloadButtonTapped(_ button: UIButton) {
        guard let pdfUrls = detailedBook?.pdfUrls,
              let pdfName = button.titleLabel?.text,
              let urlString = pdfUrls[pdfName],
              let pdfUrl = URL(string: urlString) else { return }
        #if DEBUG
        print("[detail] pdfDownloadButtonTapped with: \(pdfUrls)")
        #endif
        
        view.presentPDFView(with: pdfUrl)
    }
}
