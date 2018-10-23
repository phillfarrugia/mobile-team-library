//
//  BookListViewController+CollectionView.swift
//  Mobile Team Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import MobileTeamLibraryCore

extension BookListViewController {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModels = viewModels else { return 0 }
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModels = viewModels, viewModels.count > indexPath.row,
            let bookCell = BookCollectionViewCell.collectionView(collectionView: collectionView, dequeueReusableCellAtIndexPath: indexPath) else {
            return UICollectionViewCell()
        }
        
        // Check if Cover Image already exists, if so set cover image and return cell
        let viewModel = viewModels[indexPath.row]
        bookCell.cellStyle = .CoverImage
        if let coverImage = viewModel.coverImage {
            bookCell.setCoverImage(image: coverImage)
            return bookCell
        }
        
        // Set Placeholder Cover Image
        if let placeholderImage = UIImage(named: "placeholder-cover") {
            bookCell.setCoverImage(image: placeholderImage)
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
                })
                
                // Check if Cell still exists at indexPath, if no, cell has scrolled offscreen
                viewModel.coverImage = image
                if let cell = collectionView.cellForItem(at: indexPath) as? BookCollectionViewCell {
                    // Set new Cover Image on cell
                    cell.setCoverImage(image: image)
                }
            }
        })
        
        return bookCell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return BookCollectionViewCell.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModels = viewModels, viewModels.count > indexPath.row else { return }
        selectedViewModel = viewModels[indexPath.row]
        performSegueWithIdentifier(.BookDetail, sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
