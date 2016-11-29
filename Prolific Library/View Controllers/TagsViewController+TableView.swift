//
//  TagsViewController+TableView.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

extension TagsViewController {
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModels = viewModels else { return 0 }
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModels = viewModels, viewModels.count > indexPath.row, let tagCell = TagTableViewCell.tableView(tableView: tableView, dequeueReusableCellForViewModel: viewModels[indexPath.row], atIndexPath: indexPath) else {
            return UITableViewCell()
        }
        return tagCell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModels = viewModels, viewModels.count > indexPath.row else { return }
        selectedViewModel = viewModels[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
