//
//  BookCollectionViewCell.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit
import ProlificLibraryCore

class BookCollectionViewCell: UICollectionViewCell, Reusable {
    
    @IBOutlet var coverImageView: UIImageView!
    
    static let cellSize = CGSize(width: 95, height: 137)
    
    private weak var viewModel: BookCellViewModel?

    // MARK: Factory Method
    
    class func collectionView(collectionView: UICollectionView, dequeueReusableCellForViewModel viewModel: BookCellViewModel? = nil, atIndexPath indexPath: IndexPath) -> BookCollectionViewCell? {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BookCollectionViewCell {
            cell.viewModel = viewModel
            return cell
        }
        return nil
    }
    
    // MARK: Configuration
    
    func setCoverImage(image: UIImage) {
        self.coverImageView.image = image
    }

}