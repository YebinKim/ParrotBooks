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
        setupView()
        setupSearchBar()
        setupCollectionView()
        
        setupConstraint()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
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
        collectionView.register(SearchInfoCell.self, forCellWithReuseIdentifier: SearchInfoCell.identifier)
        collectionView.register(SearchBookCell.self, forCellWithReuseIdentifier: SearchBookCell.identifier)
        self.collectionView = collectionView
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {(
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in
            
            let sectionLayoutKind = SearchPresenter.Section.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .info:
                return self.generateInfoLayout()
            case .books:
                return self.generateBooksLayout()
            }
        }
        return layout
    }
    
    private func generateInfoLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(32)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func generateBooksLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 8, bottom: 8, trailing: 8
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
            top: 0, leading: 8, bottom: 0, trailing: 8
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
        
        presenter.searchClear()
        
        guard let name = searchBar.text else { return }
        presenter.searchBook(name)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            presenter.searchClear()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = presenter.dataSource.itemIdentifier(for: indexPath) else {
            #if DEBUG
            print("[searchCollectionView] non exist cell, index: \(indexPath)")
            #endif
            return
        }
        
        if case .books(let searchBookModel) = selectedItem {
            presenter.showDetailView(with: searchBookModel.isbn13)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.collectionViewWillDisplay(at: indexPath)
    }
}
