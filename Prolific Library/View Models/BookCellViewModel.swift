//
//  BookCellViewModel.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

public class BookCellViewModel: NSObject {
    
    private(set) public var book: Book
    
    public var title: String {
        return book.title
    }
    
    public var authors: String {
        return book.author
    }
    
    public var publisher: String? {
        if let publisher = book.publisher {
            return "\(publisher)"
        }
        return nil
    }
    
    public var categories: [String]? {
        if let categories = book.categories {
            let trimmedCategories = categories.replacingOccurrences(of: ", ", with: ",").trimmingCharacters(in: .whitespaces)
            return trimmedCategories.components(separatedBy: ",")
        }
        return nil
    }
    
    public var lastCheckedOut: String {
        if let lastCheckedOutBy = book.lastCheckedOutBy,
            let lastCheckedOut = book.lastCheckedOut {
            return "Last checked out by \(lastCheckedOutBy) on \(DateFormatter.format(lastCheckedOutDate: lastCheckedOut))"
        }
        return "Has not been checked out"
    }
    
    public var shareableMessage: String {
        return "Have you read \(title) by \(authors)?"
    }
    
    public init(book: Book) {
        self.book = book
    }
    
    public var primaryColor: UIColor = .lightGray
    
    public var secondaryColor: UIColor = .lightGray
    
    public var detailColor: UIColor = .lightGray
    
    // MARK: Static Functions
    
    public static func viewModels(fromModels models: [Book]) -> [BookCellViewModel] {
        return models.map {
            return BookCellViewModel(book: $0)
        }
    }
    
}
