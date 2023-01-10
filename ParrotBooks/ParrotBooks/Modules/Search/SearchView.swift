//
//  SearchView.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/10.
//

import UIKit

// view -> viewcontroller
protocol SearchViewDelegate: AnyObject {
    func setup(searchBar: UISearchBar)
    func pushDetailView(with isbn13: String)
}

// presenter -> view
protocol SearchViewProtocol: AnyObject {
    var searchedText: String { get }
    
    func showSearchResult(_ isShow: Bool)
    func showDetailBook(with isbn13: String)
    func configureDataSource()
}

final class SearchView: UIView {
    
    // MARK: - delegate & presenter
    weak var delegate: SearchViewDelegate?
    var presenter: SearchPresenterProtocol = SearchPresenter()
    
    // MARK: - UI
    private var collectionView: UICollectionView!
    
    private let searchBar = UISearchBar()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .large
        return indicatorView
    }()
    
    // MARK: Sendable Properties
    private var searchBarText: String = ""
    
    // MARK: - Interfaces
    func setupUI() {
        setupView()
        setupSearchBar()
        setupCollectionView()
        
        setupConstraint()
        
        configureDataSource()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        self.backgroundColor = .white
    }
    
    private func setupSearchBar() {
        delegate?.setup(searchBar: searchBar)
        searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        let collectionViewLayout: UICollectionViewLayout = generateLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.intiateHidden(true)
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
        self.addSubview(collectionView)
        self.addSubview(indicatorView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}

// MARK: - Interfaces
extension SearchView: SearchViewProtocol {
    
    var searchedText: String {
        searchBarText
    }
    
    func showSearchResult(_ isShow: Bool) {
        let duration: TimeInterval = 0.3

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if isShow {
                UIView.animate(withDuration: duration, animations: {
                    self.indicatorView.alpha = 0.0
                    self.collectionView.alpha = 1.0
                }, completion: { _ in
                    self.indicatorView.stopAnimating()
                    self.collectionView.isHidden = false
                })
            } else {
                self.indicatorView.startAnimating()

                UIView.animate(withDuration: duration, animations: {
                    self.indicatorView.alpha = 1.0
                    self.collectionView.alpha = 0.0
                }, completion: { _ in
                    self.collectionView.isHidden = true
                })
            }
        }
    }
    
    func showDetailBook(with isbn13: String) {
        delegate?.pushDetailView(with: isbn13)
    }
    
    func configureDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<SearchPresenter.Section, SearchPresenter.Item>(
            collectionView: collectionView
        ) {(
            collectionView: UICollectionView,
            indexPath: IndexPath,
            item: SearchPresenter.Item
        ) -> UICollectionViewCell? in
            
            let sectionType = SearchPresenter.Section.allCases[indexPath.section]
            switch sectionType {
            case .info:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchInfoCell.identifier,
                    for: indexPath
                ) as? SearchInfoCell else {
                    fatalError("[search] Could not create new cell")
                }
                cell.configureCell(totalCount: self.presenter.totalCount, currentPage: self.presenter.currentPage, lastPage: self.presenter.lastPage)
                return cell
            case .books:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchBookCell.identifier,
                    for: indexPath
                ) as? SearchBookCell else {
                    fatalError("[search] Could not create new cell")
                }
                cell.delegate = self
                cell.configureCell(self.presenter.books[indexPath.row])
                return cell
            }
        }
        
        presenter.configureDataSource(dataSource)
    }
}

extension SearchView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText = searchText
        presenter.searchBook(with: searchBarText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        #if DEBUG
        print("[searchBar] text: \(searchBar.text ?? "no text")")
        #endif
        
        guard let searchText = searchBar.text else { return }
        searchBarText = searchText
        presenter.searchBook(with: searchBarText)
    }
}

extension SearchView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.collectionViewWillDisplay(at: indexPath)
    }
}

extension SearchView: SearchBookCellDelegate {
    
    func storeUrlButtonTapped(with urlString: String) {
        presenter.storeUrlButtonTapped(with: urlString)
    }
}
