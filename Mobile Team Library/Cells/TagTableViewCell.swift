//
//  TagTableViewCell.swift
//  Mobile Team Library
//
//  Created by Phill Farrugia on 29/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import UIKit
import MobileTeamLibraryCore

class TagTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet private var colourView: UIView!
    @IBOutlet var titleLabel: UILabel!

    static let cellHeight: CGFloat = 44.0
    
    private var viewModel: TagViewModel? {
        didSet {
            configure(forViewModel: viewModel)
        }
    }
    
    // MARK: Factory Method
    
    class func tableView(tableView: UITableView, dequeueReusableCellForViewModel viewModel: TagViewModel, atIndexPath indexPath: IndexPath) -> TagTableViewCell? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TagTableViewCell {
            cell.viewModel = viewModel
            return cell
        }
        return nil
    }
    
    // MARK: Configure
    
    private func configure(forViewModel viewModel: TagViewModel?) {
        if let viewModel = viewModel {
            titleLabel.text = viewModel.title
            colourView.layer.cornerRadius = colourView.bounds.size.height/2
            colourView.backgroundColor = viewModel.color
        }
    }
    
}
