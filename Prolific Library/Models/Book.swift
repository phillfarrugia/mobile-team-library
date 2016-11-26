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
    
    let identifier: Int?
    let url: String?
    
    let title: String
    let author: String
    
    let publisher: String?
    let categories: String?
    
    let lastCheckedOut: Date?
    let lastCheckedOutBy: String?
    
    init(identifier: Int, url: String, title: String, author: String, publisher: String, categories: String,
         lastCheckedOut: Date, lastCheckedOutBy: String) {
        self.identifier = identifier
        self.url = url
        self.title = title
        self.author = author
        self.publisher = publisher
        self.categories = categories
        self.lastCheckedOut = lastCheckedOut
        self.lastCheckedOutBy = lastCheckedOutBy
    }
    
    init(title: String, author: String, publisher: String? = nil, categories: String? = nil) {
        self.title = title
        self.author = author
        self.publisher = publisher
        self.categories = categories
        self.identifier = nil
        self.url = nil
        self.lastCheckedOut = nil
        self.lastCheckedOutBy = nil
    }
    
    // MARK: Serialization
    
    func toDict() -> [String: String] {
        var dict: [String: String] = [:]
        dict["title"] = title
        dict["author"] = author
        
        if let publisher = publisher {
            dict["publisher"] = publisher
        }
        
        if let categories = categories {
            dict["categories"] = categories
        }
        
        return dict
    }
    
    // MARK: Deserialization
    
    required init?(json: JSON) {
        guard let identifier: Int = "id" <~~ json else { return nil }
        guard let url: String = "url" <~~ json else { return nil }
        guard let title: String = "title" <~~ json else { return nil }
        guard let author: String = "author" <~~ json else { return nil }
        
        self.identifier = identifier
        self.url = url
        self.title = title
        self.author = author
        self.publisher = "publisher" <~~ json
        self.categories = "categories" <~~ json
        self.lastCheckedOut = "lastCheckedOut" <~~ json
        self.lastCheckedOutBy = "lastCheckedOutBy" <~~ json
    }
    
}
