//
//  BookListViewController+CollectionView.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import ProlificLibraryCore

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
        
        let viewModel = viewModels[indexPath.row]
        let queryString = "\(viewModel.title) \(viewModel.authors)"
        bookCell.cellStyle = .CoverImage
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
                })
            }
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? BookCollectionViewCell,
                let image = image else {
                    // Cell at IndexPath is no longer visible on screen
                    // Request image response is cached locally by AlamofireImage
                    return
            }
            cell.setCoverImage(image: image)
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
