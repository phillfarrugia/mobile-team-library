//
//  TagsViewController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import ProlificLibraryCore

class TagsViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    internal var viewModels: [TagViewModel]?
    
    internal var viewStyle: ViewStyle = .Cover {
        didSet {
            configureViewStyle(viewStyle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tags"
    }
    
    private func configureCollectionView() {
        collectionView.registerReusableCell(BookCollectionViewCell.self)
    }
    
    private func configureViewStyle(_ viewStyle: ViewStyle) {
        // TODO:
    }
    
}
