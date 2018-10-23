//
//  GenericBookCoverList.swift
//  Mobile Team Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import MobileTeamLibraryCore

protocol GenericBookCoverListViewController {
    
    var tableView: UITableView! { get set }
    var collectionView: UICollectionView! { get set }
    
    var viewStyle: ViewStyle { get set }
    
    var tableViewCellHeight: CGFloat { get set }
    
    // MARK: Configuration
    func configureTableView()
    func configureCollectionView()
    
    // MARK: View Style
    func configureViewStyle(_ viewStyle: ViewStyle)
    mutating func toggleViewStyleButtonDidPress()
    
    // MARK: Pull to Refresh
    func didPullToRefresh()
    func endPullToRefresh()
    
    func fetchAllBooks(_ completion: @escaping ((_ books: [Book]) -> Void))
    
    // MARK: Error States
    func handleGetBooksError()
    func handleDeleteBookError()
}

extension GenericBookCoverListViewController where Self: UIViewController, Self: UICollectionViewDataSource, Self: UICollectionViewDelegate, Self: UITableViewDataSource, Self: UITableViewDelegate {
    
    func configureTableView() {
        tableView.registerReusableCell(BookTableViewCell.self)
        tableView.registerReusableCell(TagTableViewCell.self)
        tableView.rowHeight = tableViewCellHeight
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureCollectionView() {
        collectionView.registerReusableCell(BookCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetchAllBooks(_ completion: @escaping ((_ books: [Book]) -> Void)) {
        NetworkRequestManager.fetchAllBooksRequest {
            books, error in
            guard let books = books else {
                self.handleGetBooksError()
                self.endPullToRefresh()
                return
            }
            completion(books)
        }
    }
    
}
