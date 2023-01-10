//
//  DetailView.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/10.
//

import UIKit
import PDFKit

// view -> viewcontroller
protocol DetailViewDelegate: AnyObject {
    func presentPDFView(with url: URL)
}

// presenter -> view
protocol DetailViewProtocol: AnyObject {
    func setupView(with book: DetailBookModel)
    func presentPDFView(with url: URL)
}

final class DetailView: UIView {
    
    // MARK: - delegate & presenter
    weak var delegate: DetailViewDelegate?
    var presenter: DetailPresenterProtocol = DetailPresenter()
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 10
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let publisherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let pagesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let isbn10Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let isbn13Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let storeUrlButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.isHidden = true
        button.setTitle("스토어 바로가기", for: .normal)
        return button
    }()
    
    func setupUI() {
        setupView()
        setupStoreUrlButton()
        
        setupConstraint()
        
        presenter.fetchDetailBook(with: presenter.isbn13)
    }
    
    private func setupView() {
        self.backgroundColor = .white
    }
    
    private func setupStoreUrlButton() {
        storeUrlButton.addTarget(self, action: #selector(storeUrlButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraint() {
        self.addSubview(mainScrollView)
        mainScrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(imageStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainStackView.addArrangedSubview(authorLabel)
        mainStackView.addArrangedSubview(publisherLabel)
        mainStackView.addArrangedSubview(pagesLabel)
        mainStackView.addArrangedSubview(yearLabel)
        mainStackView.addArrangedSubview(ratingLabel)
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.addArrangedSubview(languageLabel)
        mainStackView.addArrangedSubview(isbn10Label)
        mainStackView.addArrangedSubview(isbn13Label)
        mainStackView.addArrangedSubview(storeUrlButton)
        
        imageStackView.addArrangedSubview(imageView)
        
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        storeUrlButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            mainScrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainScrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            
            imageStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            storeUrlButton.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
        ])
    }
    
    private func pdfDownloadButton(name: String, urlString: String) -> UIButton {
        let button = UIButton(configuration: .filled())
        button.setTitle(name, for: .normal)
        return button
    }
    
    @objc
    private func storeUrlButtonTapped() {
        presenter.storeUrlButtonTapped(with: presenter.detailedBook?.storeUrl)
    }
    
    @objc
    private func pdfDownloadButtonTapped(_ button: UIButton) {
        presenter.pdfDownloadButtonTapped(button)
    }
}


extension DetailView: DetailViewProtocol {
    
    func setupView(with book: DetailBookModel) {
        titleLabel.text = book.title
        subtitleLabel.text = book.subtitle
        descriptionLabel.text = "Description: \(book.description)"
        authorLabel.text = "Author: \(book.authors)"
        publisherLabel.text = "Publisher: \(book.publisher)"
        pagesLabel.text = "Pages: \(book.pages)"
        yearLabel.text = "Year: \(book.year)"
        ratingLabel.text = "Rating: \(book.rating)"
        priceLabel.text = "Price: \(book.price)"
        
        if let languageText = book.language {
            languageLabel.text = "Language: \(languageText)"
        }
        languageLabel.isHidden = book.language == nil
        
        isbn10Label.text = "ISBN10: \(book.isbn10)"
        isbn13Label.text = "ISBN13: \(book.isbn13)"
        
        storeUrlButton.isHidden = book.storeUrl == ""
        
        if let url = URL(string: book.imageUrl) {
            Task {
                imageView.image = try await ImageLoader().fetch(url)
            }
        }
        
        if let pdfUrls = book.pdfUrls {
            let sortedPdfUrls = pdfUrls.sorted { $0.0 < $1.0 }
            for (name, urlString) in sortedPdfUrls {
                
                let pdfDownloadButton = pdfDownloadButton(name: name, urlString: urlString)
                mainStackView.addArrangedSubview(pdfDownloadButton)
                pdfDownloadButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    pdfDownloadButton.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
                ])
                
                pdfDownloadButton.addTarget(self, action: #selector(pdfDownloadButtonTapped(_:)), for: .touchUpInside)
            }
        }
    }
    
    func presentPDFView(with url: URL) {
        delegate?.presentPDFView(with: url)
    }
}
