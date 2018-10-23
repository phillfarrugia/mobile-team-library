//
//  BookCollectionViewCell.swift
//  Mobile Team Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit
import MobileTeamLibraryCore

class BookCollectionViewCell: UICollectionViewCell, Reusable {
    
    enum CellStyle {
        case CoverImage
        case ColouredLabel
    }
    
    @IBOutlet internal var coverImageView: UIImageView!
    @IBOutlet internal var borderView: UIView!
    @IBOutlet internal var titleLabel: UILabel!
    
    static let cellSize = CGSize(width: 95, height: 137)
    
    var cellStyle: CellStyle = .CoverImage {
        didSet {
            configure(forCellStyle: cellStyle)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = UIColor.white.cgColor
    }

    // MARK: Factory Method
    
    class func collectionView(collectionView: UICollectionView, dequeueReusableCellAtIndexPath indexPath: IndexPath) -> BookCollectionViewCell? {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BookCollectionViewCell {
            return cell
        }
        return nil
    }
    
    // MARK: Configuration
    
    private func configure(forCellStyle cellStyle: CellStyle) {
        switch (cellStyle) {
        case .CoverImage:
            coverImageView.isHidden = false
            borderView.isHidden = true
            titleLabel.isHidden = true
        case .ColouredLabel:
            coverImageView.isHidden = true
            borderView.isHidden = false
            titleLabel.isHidden = false
        }
    }
    
    func setCoverImage(image: UIImage) {
        self.coverImageView.image = image
    }
    
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }

}
