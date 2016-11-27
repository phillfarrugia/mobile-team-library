//
//  NetworkRequestManager+DELETE.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 26/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import Alamofire
import Gloss
import ProlificLibraryCore

extension NetworkRequestManager {
    
    // MARK: - DELETE - Delete a Library Book
    
    typealias DeleteBookRequestCompletion = (_ error: Error?) -> Void
    
    static func deleteBookRequest(book: Book, completion: @escaping DeleteBookRequestCompletion) {
        guard let bookURL = book.url else { return }
        Alamofire.request("\(NetworkRequestManager.baseURL)\(bookURL)", method: .delete).responseJSON {
            response in
            switch response.result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    // MARK: - DELETE - Clear All Books
    
    typealias ClearBooksRequestCompletion = (_ error: Error?) -> Void
    
    static func clearBooksRequest(completion: @escaping ClearBooksRequestCompletion) {
        Alamofire.request("\(NetworkRequestManager.baseURL)/clean", method: .delete).responseJSON {
            response in
            switch response.result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
}
