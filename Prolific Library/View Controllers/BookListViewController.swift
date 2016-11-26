//
//  BookListViewController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit

class BookListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet private var tableView: UITableView!
    
    internal var viewModels: [BookCellViewModel]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Books"
        configureTableView()
        configureNavigation()
        sampleBookViewModels()
    }
    
    private func configureTableView() {
        tableView.registerReusableCell(BookTableViewCell.self)
        tableView.rowHeight = BookTableViewCell.cellHeight
        tableView.dataSource = self
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(BookListViewController.addBarButtonItemDidPress))
    }
    
    internal func addBarButtonItemDidPress() {
        // TODO: Segue to Add Books View Controller
    }
    
    private func sampleBookViewModels() {
        let bookOne = Book(title: "Programming Android", author: "Zigurd Mednieks, Laird Dornin, G. Blake Meike, Masumi Nakamura", publisher: "O'Reilly Media", categories: "android")
        let bookTwo = Book(title: "iOS Programming: The Big Nerd Ranch Guide", author: "Joe Conway and Aaron Hillegass", publisher: "Big Nerd Ranch", categories: "big nerd ranch, ios")
        viewModels = BookCellViewModel.viewModels(fromModels: [bookOne, bookTwo])
    }

}
