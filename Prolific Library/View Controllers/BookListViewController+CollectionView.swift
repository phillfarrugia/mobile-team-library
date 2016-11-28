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
        guard let viewModels = viewModels, viewModels.count > indexPath.row, let bookCell = BookCollectionViewCell.collectionView(collectionView: collectionView, dequeueReusableCellForViewModel: viewModels[indexPath.row], atIndexPath: indexPath) else {
            return UICollectionViewCell()
        }
        
        BookCellViewModel.downloadAndCacheCoverImage(forViewModel: viewModels[indexPath.row], completion: {
            image, error in
            
            // Get Image Colours
            if let image = image {
                BookCellViewModel.colors(forImage: image, completion: {
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
                    // Reqyest image response is cached locally by AlamofireImage
                    return
            }
            cell.setCoverImage(image: image)
        })
        
        return bookCell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 137)
    }
    
}
