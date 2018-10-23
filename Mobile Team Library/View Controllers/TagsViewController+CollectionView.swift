//
//  TagsViewController+CollectionView.swift
//  Mobile Team Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import MobileTeamLibraryCore

extension TagsViewController {
    
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
        bookCell.cellStyle = .ColouredLabel
        bookCell.setTitle(viewModel.title)
        bookCell.backgroundColor = viewModel.color
        
        return bookCell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return BookCollectionViewCell.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModels = viewModels, viewModels.count > indexPath.row else { return }
        selectedViewModel = viewModels[indexPath.row]
        performSegueWithIdentifier(.TagSelected, sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
