//
//  SearchPresenter.swift
//  ParrotBooks
//
//  Created by vivi on 2023/01/06.
//

import UIKit

// view -> presenter
protocol SearchPresenterProtocol {
    var hasNextPage: Bool { get }
    var totalCount: Int { get }
    var lastPage: Int { get }
    var currentPage: Int { get set }
    
    var books: [SearchBookModel.Book] { get set }
    
    func searchBook(with name: String)
    func searchClear()
    
    func collectionViewWillDisplay(at indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    
    func configureDataSource(_ dataSource: UICollectionViewDiffableDataSource<SearchPresenter.Section, SearchPresenter.Item>)
    
    func storeUrlButtonTapped(with urlString: String)
}

final class SearchPresenter: SearchPresenterProtocol {
    
    typealias Book = SearchBookModel.Book
    
    enum Item: Hashable {
        case info(SearchBookModel)
        case books(Book)
    }
    
    enum Section: CaseIterable {
        case info
        case books
    }
    
    // MARK: - Constant
    private let paging: Int = 10
    
    // MARK: - View
    private weak var view: SearchViewProtocol!
    
    // MARK: - View State
    private var viewState: SearchViewState = .list {
        didSet {
            guard viewState != oldValue else { return }
            
            switch viewState {
            case .list:
                view.showSearchResult(true)
            case .search:
                view.showSearchResult(false)
            }
        }
    }
    
    // MARK: - Model
    private var searchedBook: SearchBookModel?
    private(set) var selectedBook: SearchBookModel?
    
    // MARK: - Helper
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private let debouncer = Debouncer(minimumDelay: 0.3)
    
    var hasNextPage: Bool {
        lastPage > currentPage
    }
    var totalCount: Int {
        if let searchedBook {
            return Int(searchedBook.total) ?? 0
        } else {
            return 0
        }
    }
    var lastPage: Int {
        totalCount / paging + 1
    }
    var currentPage: Int = 1
    var books: [Book] = [] {
        didSet {
            Task { @MainActor in
                let snapshot = self.snapshotForCurrentState()
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
    }
    
    // MARK: - Initializer
    init(
        view: SearchViewProtocol? = nil,
        searchedBook: SearchBookModel? = nil
    ) {
        self.view = view
        self.searchedBook = searchedBook
    }
    
    func searchBook(with name: String) {
        Task {
            searchClear()
            await searchBook(with: name, page: currentPage)
            
            viewState = .search
        }
    }
    
    func searchBook(with name: String, page: Int) async {
        await debouncer.debounce {
            guard let response = try? await SessionManager().searchBook(name: name, page: page) else {
                return
            }
            
            switch response.result {
            case .success(let searchedBook):
                guard self.searchedBook?.books != searchedBook.books else { return }
                
                self.searchedBook = searchedBook
                self.books.append(contentsOf: searchedBook.books)
            case .failure(let error):
                #if DEBUG
                print("[search] searchBook error: \(error)")
                #endif
            }
            
            self.viewState = .list
        }
    }
    
    func searchClear() {
        books = []
        currentPage = 1
        searchedBook = nil
    }
    
    func collectionViewWillDisplay(at indexPath: IndexPath) {
        let halfPageCount: Int = paging / 2
        let isCloseToBottom: Bool = indexPath.row == books.count - halfPageCount
        
        if hasNextPage, isCloseToBottom {
            currentPage += 1
            
            Task {
                await searchBook(with: view.searchedText, page: currentPage)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else {
            #if DEBUG
            print("[searchCollectionView] non exist cell, index: \(indexPath)")
            #endif
            return
        }

        if case .books(let searchBookModel) = selectedItem {
            view.showDetailBook(with: searchBookModel.isbn13)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func configureDataSource(_ dataSource: UICollectionViewDiffableDataSource<Section, Item>) {
        Task { @MainActor in
            self.dataSource = dataSource
            let snapshot = self.snapshotForCurrentState()
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    private func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        guard let searchedBook else { return snapshot }
        
        snapshot.appendSections([Section.info])
        snapshot.appendItems([Item.info(searchedBook)])
        
        snapshot.appendSections([Section.books])
        var items: [Item] = []
        for item in books {
            items.append(Item.books(item))
        }
        snapshot.appendItems(items)
        return snapshot
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
