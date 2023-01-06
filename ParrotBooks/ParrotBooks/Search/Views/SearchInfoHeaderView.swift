//
//  SearchInfoHeaderView.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

class SearchInfoHeaderView: UICollectionReusableView {
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private let totalCountLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let currentPageLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    func configureView(totalCountText: String, currentPageText: String) {
        totalCountLabel.text = totalCountText
        currentPageLabel.text = currentPageText
    }
    
    private func setupUI() {
        setupConstraint()
    }
    
    private func setupConstraint() {
        self.addSubview(labelStackView)
        
        labelStackView.addArrangedSubview(totalCountLabel)
        labelStackView.addArrangedSubview(currentPageLabel)
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
        ])
    }
}
