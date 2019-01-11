//
//  User.swift
//  Michigan Hackers
//
//  Created by Thomas Smith on 1/10/19.
//  Copyright © 2019 Connor Svrcek. All rights reserved.
//

import Foundation

// A User is an object representing the public data for a given user of the app.
//  The data to form this object can be obtained using a ProfileDataHandler.
class User: NSObject {
    private let bio: String?
    private let majors: [String]
    private let name: String
    private let teams: [String]
    private let title: String?
    private let uid: String
    private let year: String

    init(bio: String?, majors: [String], name: String, teams: [String], title: String?, uid: String, year: String) {
        self.bio = bio
        self.majors = majors
        self.name = name
        self.teams = teams
        self.title = title
        self.uid = uid
        self.year = year
    }
}
