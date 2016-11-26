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
    
    private var viewModels: [BookCellViewModel]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Books"
        configureTableView()
        sampleBookViewModels()
    }
    
    private func configureTableView() {
        tableView.registerReusableCell(BookTableViewCell.self)
        tableView.dataSource = self
    }
    
    private func sampleBookViewModels() {
        let bookOne = Book(title: "Programming Android", author: "Zigurd Mednieks, Laird Dornin, G. Blake Meike, Masumi Nakamura", publisher: "O'Reilly Media", categories: "android")
        let bookTwo = Book(title: "iOS Programming: The Big Nerd Ranch Guide", author: "Joe Conway and Aaron Hillegass", publisher: "Big Nerd Ranch", categories: "big nerd ranch, ios")
        viewModels = BookCellViewModel.viewModels(fromModels: [bookOne, bookTwo])
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModels = viewModels else { return 0 }
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModels = viewModels, viewModels.count > indexPath.row,
            let bookCell = BookTableViewCell.tableView(tableView: tableView, dequeueReusableCellForViewModel: viewModels[indexPath.row], atIndexPath: indexPath) else {
            return UITableViewCell()
        }
        return bookCell
    }

}
