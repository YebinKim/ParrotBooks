//
//  SearchBookCell.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

protocol SearchBookCellDelegate: AnyObject {
    func storeUrlButtonTapped(with urlString: String)
}

final class SearchBookCell: UICollectionViewCell {
    
    weak var delegate: SearchBookCellDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private let isbn13Label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let storeUrlButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitle("스토어 바로가기", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    private var storeUrlString: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        priceLabel.text = nil
        isbn13Label.text = nil
        storeUrlString = ""
        imageView.image = nil
    }
    
    func configureCell(_ book: SearchModel) {
        titleLabel.text = book.title
        subtitleLabel.text = book.subtitle
        priceLabel.text = "Price: \(book.price)"
        isbn13Label.text = "ISBN13: \(book.isbn13)"
        storeUrlString = book.storeUrl
        
        if let url = URL(string: book.imageUrl) {
            Task {
                imageView.image = try await ImageLoader().fetch(url)
            }
        }
    }
    
    private func setupUI() {
        setupStoreUrlButton()
        setupConstraint()
    }
    
    private func setupStoreUrlButton() {
        storeUrlButton.addTarget(self, action: #selector(storeUrlButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraint() {
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(labelStackView)
        self.contentView.addSubview(storeUrlButton)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)
        labelStackView.addArrangedSubview(priceLabel)
        labelStackView.addArrangedSubview(isbn13Label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        storeUrlButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 96),
            
            labelStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            labelStackView.bottomAnchor.constraint(equalTo: self.storeUrlButton.topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            storeUrlButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            storeUrlButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc
    private func storeUrlButtonTapped() {
        delegate?.storeUrlButtonTapped(with: storeUrlString)
    }
}
