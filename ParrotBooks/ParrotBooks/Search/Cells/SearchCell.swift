//
//  SearchCell.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

final class SearchCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .orange
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
        label.text = "titleLabel"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "subtitleLabel"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "priceLabel"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private let isbn13Label: UILabel = {
        let label = UILabel()
        label.text = "isbn13Label"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let storeUrlButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitle("스토어 바로가기", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
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
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 96),
            
            labelStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            labelStackView.bottomAnchor.constraint(equalTo: self.storeUrlButton.topAnchor, constant: -8),
            labelStackView.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            storeUrlButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            storeUrlButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc
    private func storeUrlButtonTapped() {
    }
}
