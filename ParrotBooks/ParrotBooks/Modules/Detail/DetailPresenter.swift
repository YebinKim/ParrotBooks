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
    
    func fetchDetailBook(with isbn13: String?)
    
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
    
    func fetchDetailBook(with isbn13: String?) {
        guard let isbn13 else { return }
        
        SessionManager().detailBook(isbn13: isbn13) { response in
            switch response.result {
            case .success(let detailedBook):
                self.detailedBook = detailedBook
                DispatchQueue.main.async {
                    self.view.setupView(with: detailedBook)
                }
            case .failure(let error):
                #if DEBUG
                print("[detail] detailBook error: \(error)")
                #endif
            }
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
              let name = button.titleLabel?.text else { return }
        #if DEBUG
        print("[detail] pdfDownloadButtonTapped with: \(pdfUrls)")
        #endif
        
        if let urlString = pdfUrls[name],
           let url = URL(string: urlString) {
            DispatchQueue.global().async { [weak self] in
                let pdfDocument = PDFDocument(url: url)
                DispatchQueue.main.async {
                    self?.view.setupPdfView(document: pdfDocument)
                }
            }
        }
    }
}
