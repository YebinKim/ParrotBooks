//
//  PdfViewController.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/10.
//

import UIKit

final class PdfViewController: UIViewController {
    
    private let pdfView = PdfView()
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        let presenter = PdfPresenter(view: pdfView, url: url)
        pdfView.presenter = presenter
        pdfView.delegate = self
        pdfView.setupUI()
    }
    
    private func setupConstraints() {
        self.view.addSubview(pdfView)
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: self.view.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            pdfView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}

extension PdfViewController: PdfViewDelegate {}
