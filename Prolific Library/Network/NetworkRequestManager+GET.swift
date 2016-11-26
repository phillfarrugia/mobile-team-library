//
//  NetworkRequestManager+GET.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

extension NetworkRequestManager {
    
    // MARK: - GET - List All Library Books
    
    typealias GetAllBooksRequestCompletion = (_ books: [Book]?, _ error: Error?) -> Void
    
    static func fetchAllBooksRequest(completion: @escaping GetAllBooksRequestCompletion) {
        Alamofire.request("\(NetworkRequestManager.baseURL)/books", method: .get).responseJSON {
            response in
            switch response.result {
            case .success(let data):
                guard let booksJSON = data as? [JSON], let books = [Book].from(jsonArray: booksJSON) else {
                    completion(nil, nil)
                    return
                }
                completion(books, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    // MARK: - GET - Get a Library Book
    
    typealias GetBookDetailRequestCompletion = (_ book: Book?, _ error: Error?) -> Void
    
    static func fetchBookDetailRequest(bookURL: String, completion: @escaping GetBookDetailRequestCompletion) {
        Alamofire.request("\(NetworkRequestManager.baseURL)\(bookURL)", method: .get).responseJSON {
            response in
            switch response.result {
            case .success(let data):
                guard let bookJSON = data as? JSON, let book = Book(json: bookJSON) else {
                    completion(nil, nil)
                    return
                }
                completion(book, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
