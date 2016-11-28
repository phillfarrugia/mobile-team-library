//
//  BookListViewController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit
import ProlificLibraryCore

@objc enum ViewStyle: Int {
    case List
    case Cover
}

class BookListViewController: UIViewController, GenericBookCoverListViewController, UITableViewDataSource, UITableViewDelegate, SegueHandlerType, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum SegueIdentifier: String {
        case AddBook
        case BookDetail
    }
    
    @IBOutlet internal var tableView: UITableView!
    @IBOutlet internal var collectionView: UICollectionView!
    
    internal var viewModels: [BookCellViewModel]? {
        didSet {
            tableView.reloadData()
            collectionView.reloadData()
        }
    }
    
    internal var selectedViewModel: BookCellViewModel?
    
    internal var viewStyle: ViewStyle = .List {
        didSet {
            configureViewStyle(viewStyle)
        }
    }
    
    internal var tableViewCellHeight: CGFloat = BookTableViewCell.cellHeight

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Books"
        configureTableView()
        configureCollectionView()
        configureRefreshControl()
        
        configureNavigation()
        configureViewStyle(viewStyle)
//        fetchAllBooks {
//            books in
//            self.viewModels = BookCellViewModel.viewModels(fromModels: books)
//        }
        self.viewModels = BookCellViewModel.viewModels(fromModels: sampleBooks())
    }
    
    func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(BookListViewController.addBarButtonItemDidPress))
    }
    
    // MARK: View Style
    
    func configureViewStyle(_ viewStyle: ViewStyle) {
        switch (viewStyle) {
        case .List:
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.isHidden = true
                self.tableView.isHidden = false
            })
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cover-icon"), style: .plain, target: self, action: #selector(BookListViewController.toggleViewStyleButtonDidPress))
        case .Cover:
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.isHidden = false
                self.tableView.isHidden = true
            })
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "list-icon"), style: .plain, target: self, action: #selector(BookListViewController.toggleViewStyleButtonDidPress))
        }
    }
    
    func toggleViewStyleButtonDidPress() {
        switch (viewStyle) {
        case .List:
            viewStyle = .Cover
        case .Cover:
            viewStyle = .List
        }
    }
    
    // MARK: Pull to Refresh
    
    private func configureRefreshControl() {
        let tableViewRefreshControl = UIRefreshControl()
        tableViewRefreshControl.addTarget(self, action: #selector(BookListViewController.didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = tableViewRefreshControl
        
        let collectionViewRefreshControl = UIRefreshControl()
        collectionViewRefreshControl.addTarget(self, action: #selector(BookListViewController.didPullToRefresh), for: .valueChanged)
        collectionView.refreshControl = collectionViewRefreshControl
    }
    
    internal func didPullToRefresh() {
        self.fetchAllBooks {
            _ in
            self.endPullToRefresh()
        }
    }
    
    internal func endPullToRefresh() {
        switch (self.viewStyle) {
        case .List:
            self.tableView.refreshControl?.endRefreshing()
        case .Cover:
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    internal func addBarButtonItemDidPress() {
        performSegueWithIdentifier(.AddBook, sender: self)
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue) {
        case .AddBook:
            if let navigationController = segue.destination as? UINavigationController,
                let destinationViewController = navigationController.viewControllers.first as? AddBookViewController {
                destinationViewController.bookAddedAction = {
                    self.didPullToRefresh()
                }
            }
        case .BookDetail:
            if let destinationViewController = segue.destination as? BookDetailViewController,
                let viewModel = selectedViewModel {
                destinationViewController.configure(for: viewModel)
                selectedViewModel = nil
            }
        }
    }
    
}
