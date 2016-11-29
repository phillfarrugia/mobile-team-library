//
//  BookFilterController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 29/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

public class BookFilterController: NSObject {
    
    public static func fitler(viewModels: [BookCellViewModel], forTag tag: String) -> [BookCellViewModel] {
        return viewModels.filter {
            if let categories = $0.categories {
                return categories.contains(tag)
            }
            return false
        }
    }
    
}
