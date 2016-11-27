//
//  Book.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import Gloss

public class Book: NSObject, Decodable {
    
    public let identifier: Int?
    public let url: String?
    
    public let title: String
    public let author: String
    
    public let publisher: String?
    public let categories: String?
    
    public let lastCheckedOut: Date?
    public let lastCheckedOutBy: String?
    
    // MARK: Initializers
    
    public init(identifier: Int, url: String, title: String, author: String, publisher: String, categories: String,
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
    
    public init(title: String, author: String, publisher: String? = nil, categories: String? = nil) {
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
    
    public func toDict() -> [String: String] {
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
    
    public required init?(json: JSON) {
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
