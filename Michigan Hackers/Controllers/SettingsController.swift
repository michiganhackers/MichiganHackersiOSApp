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
    private let settingsHandler = SettingsHandler()
    private lazy var isLoggedIn = {
        return GIDSignIn.sharedInstance()?.currentUser != nil
    }()
    
    // There are three sections in the Settings TableView:
    //  0. Toggle-switch ("settings") section
    //  1. Help ("drillDown") section
    //  2. Log out ("logOut") section
    private let settingsSection = [
        "Enable notifications"
    ]
    private let drillDownSection = [
        "Help"
    ]
    private let logOutSection = [
        "Log Out"
    ]
    
    lazy var notificationsSwitch: UISwitch = {
        let notifEnabled = UISwitch(frame: .zero)
        notifEnabled.addTarget(self, action: #selector(onNotificationsSwitchChanged), for: UIControl.Event.valueChanged)
        return notifEnabled
    }()
    
    lazy var settingsSwitches = {
        return [notificationsSwitch]
    }()
    
    lazy var tableSections = {
        return [settingsSection, drillDownSection, logOutSection]
    }()
    
    // The IndexPaths of various tappable cells
    private let helpIndexPath = IndexPath(row: 0, section: 1)
    private let logOutIndexPath = IndexPath(row: 0, section: 2)
    
    // The index of the settings section in the tableSections array
    private let settingsSectionID = 0
    
    // The index of the logOut section in the tableSections array
    private let logOutSectionID = 2
    
    private func getTableSections() -> [[String]] {
        if isLoggedIn {
            return tableSections
        }
        return tableSections[0..<logOutSectionID] + Array(tableSections.dropFirst(logOutSectionID + 1))
    }
    
    private func getSection(_ section: Int) -> [String] {
        return tableSections[section]
    }
    
    @objc private func onNotificationsSwitchChanged() {
        settingsHandler.setNotificationsEnabled(val: notificationsSwitch.isOn)
    }
    
    private func updateSettingsSwitches() {
        notificationsSwitch.isOn = settingsHandler.getNotificationsEnabled()
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
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
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
    
    private func goToHelp() {
        // TODO: Do we need a help screen? If so, what information should be on
        // it?
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use a slightly gray background color to add contrast to the TableView
        // cells.
        super.view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        
        self.title = "Settings"
        
        updateSettingsSwitches()
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
        
        if indexPath.section == settingsSectionID {
            cell.accessoryView = settingsSwitches[indexPath.row]
        }
        
        // Add special styling for the log out button.
        if indexPath == logOutIndexPath && isLoggedIn {
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
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath {
        case logOutIndexPath, helpIndexPath:
            return true
        default:
            return false
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case logOutIndexPath:
            logOut()
        case helpIndexPath:
            goToHelp()
        default:
            break
            // Do nothing if none of the tappable cells are tapped.
        }
    }
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
