//
//  BookListViewController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit
import ProlificLibraryCore

class BookListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case AddBook
        case BookDetail
    }
    
    @IBOutlet internal var tableView: UITableView!
    
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
        //fetchAllBooks()
        self.viewModels = BookCellViewModel.viewModels(fromModels: sampleBooks())
    }
    
    private func sampleBooks() -> [Book] {
        let bookOne = Book(title: "Mastering iOS Frameworks", author: "Kyle Richter", publisher: "Random House Publishing", categories: "ios development,programming, dev")
        let bookTwo = Book(title: "iOS Programming: The Big Nerd Ranch Guide", author: "Aaron Hilegass", publisher: nil, categories: "ios, programming, nerds")
        let bookThree = Book(title: "iOS App Development For Dummies", author: "Jesse Feiler",publisher: nil, categories: "app development,for dummies")
        let bookFour = Book(title: "The iPhone Developer's CookBook", author: "Erica Sadun", publisher: nil, categories: "iphone, developer, cookbook")
        return [bookOne, bookTwo, bookThree, bookFour]
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(BookListViewController.toggleViewStyleBarButtonItemDidPress))
    }
    
    internal func addBarButtonItemDidPress() {
        performSegueWithIdentifier(.AddBook, sender: self)
    }
    
    internal func toggleViewStyleBarButtonItemDidPress() {
        //
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: Pull to Refresh
    
    internal func didPullToRefresh() {
        self.fetchAllBooks { 
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    internal func fetchAllBooks(_ completion: (() -> Void)? = nil) {
        NetworkRequestManager.fetchAllBooksRequest {
            books, error in
            guard let books = books else {
                self.handleGetBooksError()
                self.tableView.refreshControl?.endRefreshing()
                return
            }
            self.viewModels = BookCellViewModel.viewModels(fromModels: books)
            completion?()
        }
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
