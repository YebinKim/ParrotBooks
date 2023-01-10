//
//  PdfPresenter.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/10.
//

import UIKit
import PDFKit

// view -> presenter
protocol PdfPresenterProtocol {
    var url: URL? { get set }
    
    func fetchPdfDocument(with url: URL?)
}

final class PdfPresenter: PdfPresenterProtocol {
    
    // MARK: - View
    private weak var view: PdfViewProtocol!
    
    // MARK: - Model
    var url: URL?
    
    // MARK: - Initializer
    init(
        view: PdfViewProtocol? = nil,
        url: URL? = nil
    ) {
        self.view = view
        self.url = url
    }
    
    func fetchPdfDocument(with url: URL?) {
        guard let url else { return }
        
        DispatchQueue.global().async { [weak self] in
            guard let pdfDocument = PDFDocument(url: url) else { return }
            self?.view.setupPdfDocumnet(pdfDocument)
        }
    }
}
