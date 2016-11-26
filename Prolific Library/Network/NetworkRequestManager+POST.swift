//
//  NetworkRequestManager+POST.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

extension NetworkRequestManager {
    
    // MARK: - POST - Add a Library Book
    
    typealias PostBookRequestionCompletion = (_ book: Book?, _ error: Error?) -> Void
    
    static func postNewBookRequest(book: Book, completion: @escaping PostBookRequestionCompletion) {
        let params = book.toDict()
        Alamofire.request("\(NetworkRequestManager.baseURL)/books", method: .post, parameters: params, encoding: URLEncoding(destination: .httpBody)).responseJSON {
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
