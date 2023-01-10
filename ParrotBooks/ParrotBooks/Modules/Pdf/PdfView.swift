//
//  PdfView.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/10.
//

import UIKit
import PDFKit

// view -> viewcontroller
protocol PdfViewDelegate: AnyObject {}

// presenter -> view
protocol PdfViewProtocol: AnyObject {
    func setupPdfDocumnet(_ document: PDFDocument)
}

final class PdfView: UIView {
    
    // MARK: - delegate & presenter
    weak var delegate: PdfViewDelegate?
    var presenter: PdfPresenterProtocol = PdfPresenter()
    
    let pdfView = PDFView()
    
    func setupUI() {
        setupView()
        setupPdfView()
        
        setupConstraint()
        
        presenter.fetchPdfDocument(with: presenter.url)
    }
    
    private func setupView() {
        self.backgroundColor = .white
    }
    
    private func setupPdfView() {
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true)
    }
    
    private func setupConstraint() {
        self.addSubview(pdfView)
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            pdfView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension PdfView: PdfViewProtocol {
    
    func setupPdfDocumnet(_ document: PDFDocument) {
        DispatchQueue.main.async {
            self.pdfView.document = document
        }
    }
}
