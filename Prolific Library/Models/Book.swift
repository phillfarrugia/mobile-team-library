//
//  Book.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

class Book {
    
    let title: String
    let author: String
    
    let publisher: String
    let categories: String
    
    let lastCheckedOut: Date?
    let lastCheckedOutBy: String?
    
    init(title: String, author: String, publisher: String, categories: String,
         lastCheckedOut: Date? = nil, lastCheckedOutBy: String? = nil) {
        self.title = title
        self.author = author
        self.publisher = publisher
        self.categories = categories
        self.lastCheckedOut = lastCheckedOut
        self.lastCheckedOutBy = lastCheckedOutBy
    }
    
}
