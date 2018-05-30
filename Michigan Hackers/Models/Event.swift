//
//  Event.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 2/25/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import Foundation

class Event: NSObject {
    init(title: String, date: String, location: String, details: String) {
        self.title = title
        self.date = date
        self.location = location
        self.details = details
    }
    
    var title: String?
    var date: String?
    var location: String?
    var details: String?
}
