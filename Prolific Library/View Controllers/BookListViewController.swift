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
        let bookOne = Book(title: "Mastering iOS Frameworks", author: "Kyle Richter")
        let bookTwo = Book(title: "iOS Programming: The Big Nerd Ranch Guide", author: "Aaron Hilegass")
        let bookThree = Book(title: "iOS App Development For Dummies", author: "Jesse Feiler")
        let bookFour = Book(title: "The iPhone Developer's CookBook", author: "Erica Sadun")
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
    
    // MARK: Downloading Cover Images
    
    func downloadAndCacheCoverImage(forViewModel viewModel: BookCellViewModel, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        GoogleImageSearch.performSearch(forQuery: "\(viewModel.title) \(viewModel.authors)", completion: {
            imageURL, error in
            if let imageURL = imageURL {
                ImageHandler.sharedInstance.downloadAndCacheImage(withImageURL: imageURL, completion: {
                    image, error in
                    guard let image = image else {
                        completion(nil, error)
                        return
                    }
                    completion(image, nil)
                })
            }
            else {
                completion(nil, error)
            }
        })
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
