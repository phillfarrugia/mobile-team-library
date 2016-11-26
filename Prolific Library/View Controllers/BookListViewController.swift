//
//  BookListViewController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit

class BookListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case AddBook
        case BookDetail
    }
    
    @IBOutlet private var tableView: UITableView!
    
    internal var viewModels: [BookCellViewModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    internal var selectedViewModel: BookCellViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Books"
        configureTableView()
        configureNavigation()
        fetchAllBooks()
    }
    
    private func configureTableView() {
        tableView.registerReusableCell(BookTableViewCell.self)
        tableView.rowHeight = BookTableViewCell.cellHeight
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(BookListViewController.didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(BookListViewController.addBarButtonItemDidPress))
    }
    
    internal func addBarButtonItemDidPress() {
        performSegueWithIdentifier(.AddBook, sender: self)
    }
    
    // MARK: Pull to Refresh
    
    internal func didPullToRefresh() {
        self.fetchAllBooks { 
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue) {
        case .BookDetail:
            if let destinationViewController = segue.destination as? BookDetailViewController,
                let viewModel = selectedViewModel {
                destinationViewController.configure(for: viewModel)
                selectedViewModel = nil
            }
        default:
            return
        }
    }
    
    private func fetchAllBooks(_ completion: (() -> Void)? = nil) {
        NetworkRequestManager.fetchAllBooksRequest {
            books, error in
            guard let books = books else {
                self.handleGetBooksError()
                return
            }
            self.viewModels = BookCellViewModel.viewModels(fromModels: books)
            completion?()
        }
    }
    
    // MARK: Error State
    
    private func handleGetBooksError() {
        let alertController = UIAlertController(title: "Oh no!", message: "We were unable to retrieve a list of books. Try again?", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: {
            _ in
            self.fetchAllBooks()
        })
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: {
            _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(retryAction)
        alertController.addAction(dismissAction)
    }
    
}
