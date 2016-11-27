//
//  BookCellViewModel.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

@objc class BookCellViewModel: NSObject {
    
    private(set) var book: Book
    
    var title: String {
        return book.title
    }
    
    var authors: String {
        return book.author
    }
    
    var publisher: String {
        if let publisher = book.publisher {
            return "Publisher: \(publisher)"
        }
        return "N/A"
    }
    
    var categories: String {
        if let categories = book.categories {
            return "Tags: \(categories)"
        }
        return "N/A"
    }
    
    var lastCheckedOut: String {
        if let lastCheckedOutBy = book.lastCheckedOutBy,
            let lastCheckedOut = book.lastCheckedOut {
            return "\(lastCheckedOutBy) @ \(BookCellViewModel.format(date: lastCheckedOut))"
        }
        return "N/A"
    }
    
    var shareableMessage: String {
        return "Have you read \(title) by \(authors)?"
    }
    
    init(book: Book) {
        self.book = book
    }
    
    // MARK: Static Functions
    
    static func viewModels(fromModels models: [Book]) -> [BookCellViewModel] {
        return models.map {
            return BookCellViewModel(book: $0)
        }
    }
    
    static private func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy h:m a"
        return dateFormatter.string(from: date)
    }
    
}
