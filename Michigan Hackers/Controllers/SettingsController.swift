//
//  SettingsController.swift
//  Michigan Hackers
//
//  Created by Thomas Smith on 12/6/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController  {
    
    // There are two sections in the Settings TableView:
    //  0. Settings/help ("drillDown") section
    //  1. Log out ("logOut") section
    private let drillDownSection = [
        "Settings",
        "Help"
    ]
    private let logOutSection = [
        "Log Out"
    ]
    
    // The index of the logOut section in the tableSections array
    private let logOutSectionID = 1
    
    lazy var tableSections = {
        return [drillDownSection, logOutSection]
    }()
    
    private func getSection(_ section: Int) -> [String] {
        return tableSections[section]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use a slightly gray background color to add contrast to the TableView
        // cells.
        super.view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        
        self.title = "Settings"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellText = getSection(indexPath.section)[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "\(indexPath.section)")
        cell.textLabel?.text = cellText
        
        // Add special styling for the log out button.
        if indexPath.section == logOutSectionID {
            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSection(section).count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == logOutSectionID {
            // TODO: Log out here
        }
    }
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
