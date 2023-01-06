//
//  SearchViewController.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/05.
//

import UIKit

final class SearchViewController: UIViewController {
    
    typealias Item = SearchedBook.Book
    
    enum Section: CaseIterable {
        case books
    }
    
    private let searchBar = UISearchBar()
    
    private var searchedBook: SearchedBook? {
        didSet {
            let snapshot = snapshotForCurrentState()
            dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        configureDataSource()
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
            
            let sectionLayoutKind = Section.allCases[sectionIndex]
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
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {(
            collectionView: UICollectionView,
            indexPath: IndexPath,
            item: Item
        ) -> UICollectionViewCell? in
            
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType {
            case .books:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchCell.identifier,
                    for: indexPath
                ) as? SearchCell else {
                    fatalError("Could not create new cell")
                }
                cell.backgroundColor = .brown
                return cell
            }
        }
        
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section.books])
        
        if let books = searchedBook?.books {
            snapshot.appendItems(books)
        }
        return snapshot
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

extension SearchViewController: UICollectionViewDelegate {
    
}
