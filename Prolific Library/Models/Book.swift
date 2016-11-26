//
//  Book.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import Gloss

@objc class Book: NSObject, Decodable {
    
    let title: String
    let author: String
    
    let publisher: String?
    let categories: String?
    
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
    
    // MARK: JSON Deserialization
    
    required init?(json: JSON) {
        guard let title: String = "title" <~~ json else { return nil }
        guard let author: String = "author" <~~ json else { return nil }
        
        self.title = title
        self.author = author
        self.publisher = "publisher" <~~ json
        self.categories = "categories" <~~ json
        self.lastCheckedOut = "lastCheckedOut" <~~ json
        self.lastCheckedOutBy = "lastCheckedOutBy" <~~ json
    }
    
}
