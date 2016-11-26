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

extension NetworkRequestManager {
    
    // MARK: - PUT - Update a Library Book
    
    typealias UpdateBookRequestCompletion = (_ book: Book?, _ error: Error?) -> Void
    
    static func updateBookRequest(book: Book, completion: @escaping UpdateBookRequestCompletion) {
        let params = book.toDict()
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
