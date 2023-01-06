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
    
    weak var view: SearchViewController?
    private var searchModel: [SearchModel] = [] {
        didSet {
            let snapshot = snapshotForCurrentState()
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    required init(view: SearchViewController) {
        self.view = view
        configureDataSource()
    }
    
    func showDetailView(with isbn13: String) {
    }
    
    private func configureDataSource() {
        guard let searchCollecionView = view?.collectionView else { return }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: searchCollecionView) {(
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
                    fatalError("[search] Could not create new cell")
                }
                // FIXME: temp layout
                cell.backgroundColor = .brown
                cell.delegate = self
                cell.configureCell(self.searchModel[indexPath.row])
                return cell
            }
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
    
    func searchBook(_ name: String) {
        self.searchModel = []
        
        SessionManager().searchBook(name: name) { response in
            switch response.result {
            case .success(let searchedBook):
                for book in searchedBook.books {
                    self.searchModel.append(SearchModel.convert(from: book))
                }
            case .failure(let error):
                #if DEBUG
                print("[search] searchBook error: \(error)")
                #endif
            }
        }
    }
}

extension SearchPresenter: SearchCellDelegate {
    func storeUrlButtonTapped(with urlString: String) {
        #if DEBUG
        print("[search] storeUrlButtonTapped with: \(urlString)")
        #endif
        
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
