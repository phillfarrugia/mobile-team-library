//
//  NetworkRequestManager+PUT.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

public extension NetworkRequestManager {
    
    // MARK: - PUT - Update a Library Book
    
    public typealias UpdateBookRequestCompletion = (_ book: Book?, _ error: Error?) -> Void
    
    public static func updateBookRequest(book: Book, bookURL: String, completion: @escaping UpdateBookRequestCompletion) {
        let params = book.toDict()
        Alamofire.request("\(NetworkRequestManager.baseURL)\(bookURL)", method: .put, parameters: params, encoding: URLEncoding(destination: .httpBody)).responseJSON {
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
    
    // MARK: - PUT - Checkout a Library Book
    
    public typealias CheckoutBookRequestCompletion = (_ book: Book?, _ error: Error?) -> Void
    
    public static func checkoutBookRequest(book: Book, checkedOutBy: String, completion: @escaping UpdateBookRequestCompletion) {
        var params = book.toDict()
        params["lastCheckedOutBy"] = checkedOutBy
        guard let bookURL = book.url else { return }
        Alamofire.request("\(NetworkRequestManager.baseURL)\(bookURL)", method: .put, parameters: params, encoding: URLEncoding(destination: .httpBody)).responseJSON {
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
