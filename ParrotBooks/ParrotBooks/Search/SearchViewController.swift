//
//  SearchViewController.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    
    private var searchedBook: SearchedBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        searchBar.placeholder = "책 이름"
        searchBar.delegate = self
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        #if DEBUG
        print("[searchBar] text: \(searchBar.text ?? "no text")")
        #endif
        
        guard let bookName = searchBar.text else { return }
        SessionManager().searchBook(name: bookName) { response in
            switch response.result {
            case .success(let searchedBook):
                self.searchedBook = searchedBook
            case .failure(let error):
                #if DEBUG
                print("[searchBar] error: \(error)")
                #endif
            }
        }
    }
}
