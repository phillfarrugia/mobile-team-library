//
//  SettingsViewController+TableView.swift
//  Prolific Library
//
//  Created by Phill Farrugia on 29/11/16.
//  Copyright © 2016 Phill Farrugia. All rights reserved.
//

import Foundation

extension SettingsViewController {
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let settingsSection = SettingsSections(rawValue: section) {
            switch (settingsSection) {
            case .Actions:
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainTableViewCell", for: indexPath)
        if let settingsSection = SettingsSections(rawValue: indexPath.section) {
            switch (settingsSection) {
            case .Actions:
                cell.textLabel?.text = "Delete All Books"
            }
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let settingsSection = SettingsSections(rawValue: indexPath.section) {
            switch (settingsSection) {
            case .Actions:
                handleClearAllBooksDidPress {
                    if let deleteCell = tableView.cellForRow(at: indexPath) {
                        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                        deleteCell.accessoryView = activityIndicator
                        activityIndicator.startAnimating()
                        self.clearAllBooks {
                            deleteCell.accessoryView = nil
                        }
                    }
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let settingsSection = SettingsSections(rawValue: section) {
            return settingsSection.titleLabel
        }
        return nil
    }
    
}
