//
//  DetailViewController.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let presenter: DetailPresenter
    
    init(presenter: DetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private let pdfDownloadButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.isHidden = true
        button.setTitle("PDF 다운로드", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        presenter.fetchDetailBook()
    }
    
    func configureView(detailedBook book: DetailedBook) {
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
        pdfDownloadButton.isHidden = book.pdfUrls == nil
        
        if let url = URL(string: book.imageUrl) {
            Task {
                imageView.image = try await ImageLoader().fetch(url)
            }
        }
    }
    
    private func setupUI() {
        setupView()
        setupStoreUrlButton()
        
        setupConstraint()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    private func setupStoreUrlButton() {
        storeUrlButton.addTarget(self, action: #selector(storeUrlButtonTapped), for: .touchUpInside)
    }
    private func setupConstraint() {
        self.view.addSubview(mainScrollView)
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
        mainStackView.addArrangedSubview(pdfDownloadButton)
        
        imageStackView.addArrangedSubview(imageView)
        
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        storeUrlButton.translatesAutoresizingMaskIntoConstraints = false
        pdfDownloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            mainScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            
            imageStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            
            imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            storeUrlButton.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            
            pdfDownloadButton.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
        ])
    }
    
    @objc
    private func storeUrlButtonTapped() {
        presenter.storeUrlButtonTapped()
    }
}
