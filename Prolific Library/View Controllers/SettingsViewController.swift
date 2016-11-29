//
//  SettingsViewController.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 29/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum SettingsSections: Int {
        case Actions = 0
        case Acknowledgements
        
        static var numberOfSections: Int {
            return 2
        }
        
        var titleLabel: String {
            switch (self) {
            case .Actions:
                return "Actions"
            case .Acknowledgements:
                return "Acknowledgements"
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
    
}
