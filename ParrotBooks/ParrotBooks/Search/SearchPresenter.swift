//
//  SearchPresenter.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

protocol SearchViewPresenter {
    init(view: SearchViewController)
    func showDetailView(with isbn13: String)
}

final class SearchPresenter: SearchViewPresenter {
    
    typealias Item = SearchModel
    
    enum Section: CaseIterable {
        case books
    }
    
    private weak var view: SearchViewController?
    private var searchModel: [SearchModel] = [] {
        didSet {
            let snapshot = snapshotForCurrentState()
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private var searchedText: String = ""
    
    private let paging: Int = 10
    private var totalCount: Int = 0 {
        didSet {
            guard totalCount != oldValue else { return }
            DispatchQueue.main.async {
                self.view?.collectionView.reloadData()
            }
        }
    }
    private var currentPage: Int = 1
    private var lastPage: Int {
        totalCount / paging + 1
    }
    private var hasNextPage: Bool {
        lastPage > currentPage
    }
    
    required init(view: SearchViewController) {
        self.view = view
        configureDataSource()
    }
    
    func showDetailView(with isbn13: String) {
    }
    
    private func configureDataSource() {
        guard let searchCollecionView = view?.collectionView else { return }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: searchCollecionView
        ) {(
            collectionView: UICollectionView,
            indexPath: IndexPath,
            item: Item
        ) -> UICollectionViewCell? in
            
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType {
            case .books:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchBookCell.identifier,
                    for: indexPath
                ) as? SearchBookCell else {
                    fatalError("[search] Could not create new cell")
                }
                cell.delegate = self
                cell.configureCell(self.searchModel[indexPath.row])
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = {(
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath
        ) -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SearchInfoHeaderView.identifier,
                for: indexPath) as? SearchInfoHeaderView else {
                    fatalError("[search] Could not create header")
                }
            supplementaryView.configureView(
                totalCountText: "총 \(self.totalCount)건 검색됨",
                currentPageText: "\(self.currentPage) / \(self.lastPage)"
            )
            return supplementaryView
        }
        
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section.books])
        snapshot.appendItems(searchModel)
        return snapshot
    }
    
    func searchClear() {
        searchModel = []
        searchedText = ""
    }
    
    func searchBook(_ name: String, page: Int? = nil) {
        SessionManager().searchBook(name: name, page: page) { response in
            switch response.result {
            case .success(let searchedBook):
                for book in searchedBook.books {
                    self.searchModel.append(SearchModel.convert(from: book))
                }
                self.searchedText = name
                self.totalCount = Int(searchedBook.total) ?? 0
            case .failure(let error):
                #if DEBUG
                print("[search] searchBook error: \(error)")
                #endif
            }
        }
    }
    
    func collectionViewWillDisplay(at indexPath: IndexPath) {
        let isCloseToBottom: Bool = indexPath.row == searchModel.count - 1
        
        if hasNextPage, isCloseToBottom {
            currentPage += 1
            searchBook(searchedText, page: currentPage)
        }
    }
}

extension SearchPresenter: SearchBookCellDelegate {
    func storeUrlButtonTapped(with urlString: String) {
        #if DEBUG
        print("[search] storeUrlButtonTapped with: \(urlString)")
        #endif
        
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
