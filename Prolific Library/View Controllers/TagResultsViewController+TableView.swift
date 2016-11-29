//
//  TagResultsViewController+TableView.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 29/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import ProlificLibraryCore

extension TagResultsViewController {
    
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
        
        // Cover Image
        let viewModel = viewModels[indexPath.row]
        let queryString = "\(viewModel.title) \(viewModel.authors)"
        ImageHandler.downloadAndCacheCoverImage(forQueryString: queryString, completion: {
            image, error in
            
            // Get Image Colours
            if let image = image {
                ImageColorsHandler.colors(forImage: image, completion: {
                    primary, secondary, detail in
                    let viewModel = viewModels[indexPath.row]
                    viewModel.primaryColor = primary
                    viewModel.secondaryColor = secondary
                    viewModel.detailColor = detail
                    
                    // Set Colours on Cell
                    guard let cell = tableView.cellForRow(at: indexPath) as? BookTableViewCell else {
                        // Cell at IndexPath is no longer visible on screen
                        // Request Image response is cached locally by AlamofireImage
                        return
                    }
                    cell.layoutTagViews()
                })
            }
            
            // Set Image on Cell
            guard let cell = tableView.cellForRow(at: indexPath) as? BookTableViewCell,
                let image = image else {
                    // Cell at IndexPath is no longer visible on screen
                    // Request Image response is cached locally by AlamofireImage
                    return
            }
            cell.setCoverImage(image: image)
        })
        
        return bookCell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModels = viewModels, viewModels.count > indexPath.row else { return }
        selectedViewModel = viewModels[indexPath.row]
        performSegueWithIdentifier(.BookDetail, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
