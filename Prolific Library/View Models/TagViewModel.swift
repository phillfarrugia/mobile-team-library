//
//  TagViewModel.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

public class TagViewModel {
    
    public let title: String
    
    init(title: String) {
        self.title = title
    }
    
    public static func tagViewModels(fromBookCellViewModels bookViewModels: [BookCellViewModel]) -> [TagViewModel] {
        var tagViewModels: [TagViewModel] = []
        for bookViewModel in bookViewModels {
            if let categories = bookViewModel.categories {
                tagViewModels.append(contentsOf: categories.map { TagViewModel(title: $0) })
            }
        }
        return tagViewModels
    }
    
}
