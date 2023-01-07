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
    
    enum Item: Hashable {
        case info(SearchInfoModel)
        case books(SearchBookModel)
    }
    
    enum Section: CaseIterable {
        case info
        case books
    }
    
    private weak var view: SearchViewController?
    private var searchInfoModel = SearchInfoModel()
    private var searchBookModel: [SearchBookModel] = [] {
        didSet {
            DispatchQueue.main.async {
                let snapshot = self.snapshotForCurrentState()
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    required init(view: SearchViewController) {
        self.view = view
        configureDataSource()
    }
    
    func showDetailView(with isbn13: String) {
        let detailPresenter = DetailPresenter(isbn13: isbn13)
        let detailView = DetailViewController(presenter: detailPresenter)
        self.view?.navigationController?.present(detailView, animated: true)
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
            case .info:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchInfoCell.identifier,
                    for: indexPath
                ) as? SearchInfoCell else {
                    fatalError("[search] Could not create new cell")
                }
                cell.configureCell(searchInfoModel: self.searchInfoModel)
                return cell
            case .books:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchBookCell.identifier,
                    for: indexPath
                ) as? SearchBookCell else {
                    fatalError("[search] Could not create new cell")
                }
                cell.delegate = self
                cell.configureCell(self.searchBookModel[indexPath.row])
                return cell
            }
        }
        
        DispatchQueue.main.async {
            let snapshot = self.snapshotForCurrentState()
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section.info])
        snapshot.appendItems([Item.info(searchInfoModel)])
        
        snapshot.appendSections([Section.books])
        var items: [Item] = []
        for model in searchBookModel {
            items.append(Item.books(model))
        }
        snapshot.appendItems(items)
        return snapshot
    }
    
    func searchClear() {
        searchInfoModel = SearchInfoModel()
        searchBookModel = []
    }
    
    func searchBook(_ name: String, page: Int? = nil) {
        SessionManager().searchBook(name: name, page: page) { response in
            switch response.result {
            case .success(let searchedBook):
                if self.searchInfoModel.searchedText != name {
                    let totalCount: Int = Int(searchedBook.total) ?? 0
                    self.searchInfoModel.totalCount = totalCount
                    self.searchInfoModel.searchedText = name
                }
                
                for book in searchedBook.books {
                    self.searchBookModel.append(SearchBookModel.convert(from: book))
                }
            case .failure(let error):
                #if DEBUG
                print("[search] searchBook error: \(error)")
                #endif
            }
        }
    }
    
    func collectionViewWillDisplay(at indexPath: IndexPath) {
        let halfPageCount: Int = SearchInfoModel.paging / 2
        let isCloseToBottom: Bool = indexPath.row == searchBookModel.count - halfPageCount
        
        if searchInfoModel.hasNextPage, isCloseToBottom {
            searchInfoModel.currentPage += 1
            searchBook(searchInfoModel.searchedText, page: searchInfoModel.currentPage)
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
