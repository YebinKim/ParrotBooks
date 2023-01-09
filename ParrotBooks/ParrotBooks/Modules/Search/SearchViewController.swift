//
//  SearchViewController.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let searchView = SearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        let presenter = SearchPresenter(view: searchView)
        searchView.presenter = presenter
        searchView.delegate = self
        searchView.setupUI()
    }
    
    private func setupConstraints() {
        self.view.addSubview(searchView)
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            searchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            searchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}

extension SearchViewController: SearchViewDelegate {
    
    func setup(searchBar: UISearchBar) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        searchBar.placeholder = "책 이름"
    }
    
    func pushDetailView(with isbn13: String) {
        let detailViewController = DetailViewController(presenter: DetailPresenter(isbn13: isbn13))
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
