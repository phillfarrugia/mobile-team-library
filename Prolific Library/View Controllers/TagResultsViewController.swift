//
//  TagResultsViewController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 29/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import ProlificLibraryCore

class TagResultsViewController: UIViewController, SegueHandlerType, UITableViewDataSource, UITableViewDelegate {
    
    enum SegueIdentifier: String {
        case BookDetail
    }
    
    @IBOutlet private var tableView: UITableView!
    
    internal var selectedViewModel: BookCellViewModel?
    
    internal var viewModels: [BookCellViewModel]?
    
    internal var tagViewModel: TagViewModel? {
        didSet {
            configure(forTagViewModel: tagViewModel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.registerReusableCell(BookTableViewCell.self)
        tableView.rowHeight = BookTableViewCell.cellHeight
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configure(forTagViewModel tagViewModel: TagViewModel?) {
        if let tagViewModel = tagViewModel {
            title = tagViewModel.title
        }
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue) {
        case .BookDetail:
            if let destinationViewController = segue.destination as? BookDetailViewController,
                let viewModel = selectedViewModel {
                destinationViewController.viewModel = viewModel
                selectedViewModel = nil
            }
        }
    }
    
}
