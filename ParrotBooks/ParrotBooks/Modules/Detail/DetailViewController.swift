//
//  DetailViewController.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    private let isbn13: String
    
    init(isbn13: String) {
        self.isbn13 = isbn13
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
        let presenter = DetailPresenter(view: detailView, isbn13: isbn13)
        detailView.presenter = presenter
        detailView.delegate = self
        detailView.setupUI()
    }
    
    private func setupConstraints() {
        self.view.addSubview(detailView)
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: self.view.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}

extension DetailViewController: DetailViewDelegate {
    
    func dismissPDFView() {
        self.navigationController?.dismiss(animated: true)
    }
}
