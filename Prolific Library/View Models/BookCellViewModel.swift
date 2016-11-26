//
//  BookCellViewModel.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

@objc class BookCellViewModel: NSObject {
    
    private var book: Book
    
    var title: String {
        return book.title
    }
    
    var authors: String {
        return book.author
    }
    
    var publisher: String {
        return "Publisher: \(book.publisher)"
    }
    
    var categories: String {
        return "Tags: \(book.categories)"
    }
    
    var lastCheckedOut: String {
        if let lastCheckedOutBy = book.lastCheckedOutBy,
            let lastCheckedOut = book.lastCheckedOut {
            return "\(book.lastCheckedOutBy) @ <Date Here>"
        }
        return "N/A"
    }
    
    init(book: Book) {
        self.book = book
    }
    
    static func viewModels(fromModels models: [Book]) -> [BookCellViewModel] {
        return models.map {
            return BookCellViewModel(book: $0)
        }
    }
    
}
