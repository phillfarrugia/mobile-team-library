//
//  TagViewModel.swift
//  Mobile Team Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

public class TagViewModel: NSObject {
    
    public let title: String
    
    public let color: UIColor
    
    init(title: String) {
        self.title = title
        self.color = UIColor.getRandomColor()
    }
    
    public static func tagViewModels(fromBookCellViewModels bookViewModels: [BookCellViewModel]) -> [TagViewModel] {
        var tagViewModels: [TagViewModel] = []
        for bookViewModel in bookViewModels {
            if let categories = bookViewModel.categories {
                let tags = categories.map { TagViewModel(title: $0) }.filter {
                    return !tagViewModels.contains($0)
                }
                tagViewModels.append(contentsOf: tags)
            }
        }
        return tagViewModels
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? TagViewModel else {
            return false
        }
        let lhs = self
        return lhs.title == rhs.title
    }
    
}
