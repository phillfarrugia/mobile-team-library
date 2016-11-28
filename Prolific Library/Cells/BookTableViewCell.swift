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
    @IBOutlet private var tagViewContainer: TagBubbleViewContainer!
    
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
            layoutTagViews()
        }
    }
    
    func layoutTagViews() {
        if let viewModel = self.viewModel, let categories = viewModel.categories {
            tagViewContainer.layoutTagViews(forTags: categories, withColor: viewModel.detailColor)
        }
    }
    
    func setCoverImage(image: UIImage) {
        self.coverImageView.image = image
    }
    
}
