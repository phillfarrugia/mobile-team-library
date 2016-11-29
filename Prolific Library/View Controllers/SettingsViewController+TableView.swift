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
            case .Acknowledgements:
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
            case .Acknowledgements:
                cell.textLabel?.text = "View Acknowledgements"
            }
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let settingsSection = SettingsSections(rawValue: indexPath.section) {
            switch (settingsSection) {
            case .Actions:
                break
            case .Acknowledgements:
                break
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
