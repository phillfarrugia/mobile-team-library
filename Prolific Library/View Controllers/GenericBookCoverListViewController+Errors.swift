//
//  GenericBookCoverListViewController+Errors.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 28/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

extension GenericBookCoverListViewController where Self: UIViewController, Self: UICollectionViewDataSource, Self: UICollectionViewDelegate, Self: UITableViewDataSource, Self: UITableViewDelegate {
    
    // MARK: Error States
    
    internal func handleGetBooksError() {
        let alertController = UIAlertController(title: "Oh no!", message: "We were unable to retrieve a list of books. Try again?", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: {
            _ in
            self.fetchAllBooks {_ in 
                //
            }
        })
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: {
            _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(retryAction)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    internal func handleDeleteBookError() {
        let alertController = UIAlertController(title: "Oh no!", message: "We were unable to delete that book. Please Try again", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: {
            _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
