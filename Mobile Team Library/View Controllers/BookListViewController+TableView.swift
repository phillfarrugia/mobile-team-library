//
//  BookListViewController+DataSource.swift
//  Mobile Team Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit
import MobileTeamLibraryCore

extension BookListViewController {
    
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
        
        // Check if Cover Image already exists, if so set cover image and return cell
        let viewModel = viewModels[indexPath.row]
        if let coverImage = viewModel.coverImage {
            bookCell.setCoverImage(image: coverImage)
            return bookCell
        }
        
        // Request new Cover Image
        let queryString = "\(viewModel.title) \(viewModel.authors)"
        ImageHandler.cachedImageOrDownloadImage(forQueryString: queryString, completion: {
            image, error in
            
            // Calculate Image Colours
            if let image = image {
                ImageColorsHandler.colors(forImage: image, completion: {
                    primary, secondary, detail in
                    viewModel.primaryColor = primary
                    viewModel.secondaryColor = secondary
                    viewModel.detailColor = detail
                    
                    // Check if Cell still exists at indexPath, if no, cell has scrolled offscreen
                    // Re-Layout Tag Views with new colours
                    if let cell = tableView.cellForRow(at: indexPath) as? BookTableViewCell {
                        cell.layoutTagViews()
                    }
                })
                
                // Check if Cell still exists at indexPath, if no, cell has scrolled offscreen
                viewModel.coverImage = image
                if let cell = tableView.cellForRow(at: indexPath) as? BookTableViewCell {
                    // Set new Cover Image on cell
                    cell.setCoverImage(image: image)
                }
            }
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let viewModels = viewModels, viewModels.count > indexPath.row else { return }
            let viewModel = viewModels[indexPath.row]
            NetworkRequestManager.deleteBookRequest(book: viewModel.book, completion: {
                error in
                if let _ = error {
                    self.handleDeleteBookError()
                }
                tableView.beginUpdates()
                tableView.setEditing(false, animated: true)
                tableView.endUpdates()
                self.didPullToRefresh()
            })
        }
    }
    
}
