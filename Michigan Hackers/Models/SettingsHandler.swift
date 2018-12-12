//
//  SettingsHandler.swift
//  Michigan Hackers
//
//  Created by Thomas Smith on 12/11/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import Foundation

// The SettingsHandler class provides a type-safe method of updating the
// internal settings of the app. Getter and setter methods are provided for each
// settings that should exist.
class SettingsHandler: NSObject {
    private let defaults = UserDefaults.standard
    
    private let notifEnabledKey = "notificationsEnabled"
    
    private func registerDefaults() {
        defaults.register(defaults: [
            notifEnabledKey: true
        ])
    }
    
    func setNotificationsEnabled(val: Bool) {
        defaults.set(val, forKey: notifEnabledKey)
    }
    
    func getNotificationsEnabled() -> Bool {
        return defaults.bool(forKey: notifEnabledKey)
    }
    
    override init() {
        super.init()
        registerDefaults()
    }
}
