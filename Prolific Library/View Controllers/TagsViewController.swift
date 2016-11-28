//
//  TagsViewController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import ProlificLibraryCore

class TagsViewController: UIViewController, GenericBookCoverListViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet internal var tableView: UITableView!
    @IBOutlet internal var collectionView: UICollectionView!
    
    internal var viewModels: [TagViewModel]? {
        didSet {
            tableView.reloadData()
            collectionView.reloadData()
        }
    }
    
    internal var selectedViewModel: TagViewModel?
    
    internal var viewStyle: ViewStyle = .Cover {
        didSet {
            configureViewStyle(viewStyle)
        }
    }
    
    internal var tableViewCellHeight: CGFloat = 44.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tags"
        configureTableView()
        configureCollectionView()
        configureRefreshControl()
        configureViewStyle(viewStyle)
        
        let sampleViewModels = BookCellViewModel.viewModels(fromModels: sampleBooks())
        self.viewModels = TagViewModel.tagViewModels(fromBookCellViewModels: sampleViewModels)
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
    
}
