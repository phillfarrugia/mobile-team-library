//
//  TagsViewController+CollectionView.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

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
//        guard let viewModels = viewModels, viewModels.count > indexPath.row, let bookCell = BookCollectionViewCell.collectionView(collectionView: collectionView, dequeueReusableCellForViewModel: viewModels[indexPath.row], atIndexPath: indexPath) else {
//            return UICollectionViewCell()
//        }
        
        return UICollectionViewCell()
    }
    
}
