//
//  BookTableViewCell.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit
import ProlificLibraryCore

class BookTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var tagViewContainer: UIView!
    
    
    private weak var viewModel: BookCellViewModel? {
        didSet {
            configure(forViewModel: viewModel)
        }
    }
    
    static let cellHeight: CGFloat = 110.0
    
    // MARK: Factory Method
    
    class func tableView(tableView: UITableView, dequeueReusableCellForViewModel viewModel: BookCellViewModel? = nil, atIndexPath indexPath: IndexPath) -> BookTableViewCell? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? BookTableViewCell {
            cell.viewModel = viewModel
            return cell
        }
        return nil
    }
    
    // MARK: Configuration
    
    private func configure(forViewModel viewModel: BookCellViewModel?) {
        if let viewModel = viewModel {
            titleLabel.text = viewModel.title
            authorLabel.text = viewModel.authors
            
            if let categories = viewModel.categories {
                layoutTagViews(forTags: categories)
            }
        }
    }
    
    func setCoverImage(image: UIImage) {
        self.coverImageView.image = image
    }
    
    private func layoutTagViews(forTags tags: [String]) {
        var xOrigins: CGFloat = tagViewContainer.bounds.origin.x
        let kHoriontalMargin: CGFloat = 8.0
        removeTagViews()
        for tag in tags {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12.0)
            label.text = tag
            label.sizeToFit()
            
            let circularView = UIView()
            circularView.frame = CGRect(x: xOrigins, y: tagViewContainer.bounds.origin.y, width: label.frame.width + 20, height: label.frame.height + 8)
            circularView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            circularView.layer.cornerRadius = circularView.frame.height/2
            circularView.addSubview(label)
            
            var labelFrame = label.frame
            label.textColor = UIColor.darkGray.withAlphaComponent(0.8)
            labelFrame.origin = CGPoint(x: 10, y: 4)
            label.frame = labelFrame
            
            tagViewContainer.addSubview(circularView)
            
            xOrigins += (circularView.frame.size.width + kHoriontalMargin)
        }
    }
    
    private func removeTagViews() {
        for subview in tagViewContainer.subviews {
            subview.removeFromSuperview()
        }
    }
    
}
