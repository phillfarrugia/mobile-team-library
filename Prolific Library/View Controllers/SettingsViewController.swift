//
//  SettingsViewController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 29/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation
import ProlificLibraryCore

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum SettingsSections: Int {
        case Actions = 0
        
        static var numberOfSections: Int {
            return 1
        }
        
        var titleLabel: String {
            switch (self) {
            case .Actions:
                return "Actions"
            }
        }
    }
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    internal func handleClearAllBooksDidPress(completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Are you sure?", message: "Clearing all books cannot be undone.", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Confirm", style: .destructive, handler: {
            _ in
            completion()
        })
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(retryAction)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    internal func handleClearBooksError() {
        let alertController = UIAlertController(title: "Oh no!", message: "We were unable to delete your books. Try again?", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: {
            _ in
            self.clearAllBooks(completion: nil)
        })
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: {
            _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(retryAction)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    internal func clearAllBooks(completion: (() -> Void)?) {
        NetworkRequestManager.clearBooksRequest(completion: {
            error in
            completion?()
            guard error == nil else {
                self.handleClearBooksError()
                return
            }
        })

    }
    
}
