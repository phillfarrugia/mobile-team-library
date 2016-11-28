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
    
    private weak var viewModel: BookCellViewModel? {
        didSet {
            configure(forViewModel: viewModel)
        }
    }

    // MARK: Factory Method
    
    class func collectionView(collectionView: UICollectionView, dequeueReusableCellForViewModel viewModel: BookCellViewModel? = nil, atIndexPath indexPath: IndexPath) -> BookCollectionViewCell? {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BookCollectionViewCell {
            cell.viewModel = viewModel
            return cell
        }
        return nil
    }
    
    // MARK: Configuration
    
    private func configure(forViewModel viewModel: BookCellViewModel?) {
        if let viewModel = viewModel {
            // TODO: Configure Cell for View Model
        }
    }
    
    func setCoverImage(image: UIImage) {
        self.coverImageView.image = image
    }

}
