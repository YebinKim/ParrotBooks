//
//  SearchViewController.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import UIKit

final class SearchViewController: UIViewController {
    
    lazy var presenter = SearchPresenter(view: self)
    
    var collectionView: UICollectionView!
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        setupSearchBar()
        setupCollectionView()
        
        setupConstraint()
    }
    
    private func setupSearchBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        searchBar.placeholder = "책 이름"
        searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        let collectionViewLayout: UICollectionViewLayout = generateLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.identifier)
        self.collectionView = collectionView
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {(
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in
            
            let sectionLayoutKind = SearchPresenter.Section.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .books:
                return self.generateBooksLayout()
            }
        }
        return layout
    }
    
    private func generateBooksLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 8, leading: 8, bottom: 0, trailing: 8
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/4)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 8, leading: 8, bottom: 0, trailing: 8
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func setupConstraint() {
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        #if DEBUG
        print("[searchBar] text: \(searchBar.text ?? "no text")")
        #endif
        
        guard let name = searchBar.text else { return }
        presenter.searchBook(name)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedBook = presenter.dataSource.itemIdentifier(for: indexPath) else {
            #if DEBUG
            print("[searchCollectionView] non exist cell, index: \(indexPath)")
            #endif
            return
        }
        presenter.showDetailView(with: selectedBook.isbn13)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
