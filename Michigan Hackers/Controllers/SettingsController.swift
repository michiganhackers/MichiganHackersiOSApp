//
//  SettingsController.swift
//  Michigan Hackers
//
//  Created by Thomas Smith on 12/6/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class SettingsController: UITableViewController  {
    
    private let eventsTabIndex = 0
    private lazy var isLoggedIn = {
        return GIDSignIn.sharedInstance()?.currentUser != nil
    }()
    
    // There are two sections in the Settings TableView:
    //  0. Settings/help ("drillDown") section
    //  1. Log out ("logOut") section
    //    TODO: Don't show the log out section if the user isn't logged in
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
    
    private func getTableSections() -> [[String]] {
        if isLoggedIn {
            return tableSections
        }
        return tableSections[0..<logOutSectionID] + Array(tableSections.dropFirst(logOutSectionID + 1))
    }
    
    private func getSection(_ section: Int) -> [String] {
        return tableSections[section]
    }
    
    // Helper for showing an alert. Useful for displaying error messages.
    private func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    private func logOut() {
        // Sign out of Firebase.
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            showAlert(title: "Error Signing Out",
                      message: signOutError.localizedDescription)
        }
        
        // Sign out of Google.
        GIDSignIn.sharedInstance()?.signOut()
        
        // Reload the Events tab to show the new (not logged in) state.
        let delegate = UIApplication.shared.delegate
        if let tabBarController = delegate?.window??.rootViewController as? TabBarController {
            guard let controllers = tabBarController.viewControllers else { return }
            guard let eventsNavController =
                controllers[eventsTabIndex] as? UINavigationController else { return }
            guard let eventController =
                eventsNavController.childViewControllers[0] as? EventController else { return }
            
            // Remove events from the EventController and show the sign-in button.
            eventController.updateToLoggedOutState()
            isLoggedIn = false
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use a slightly gray background color to add contrast to the TableView
        // cells.
        super.view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        
        self.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let oldIsLoggedIn = isLoggedIn
        isLoggedIn = GIDSignIn.sharedInstance()?.currentUser != nil
        if oldIsLoggedIn != isLoggedIn {
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellText = getSection(indexPath.section)[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "\(indexPath.section)_\(isLoggedIn)")
        cell.textLabel?.text = cellText
        
        // Add special styling for the log out button.
        if indexPath.section == logOutSectionID && isLoggedIn {
            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return getTableSections().count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSection(section).count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == logOutSectionID {
            logOut()
        }
    }
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
