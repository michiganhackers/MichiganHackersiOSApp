//
//  UserProfileController.swift
//  Michigan Hackers
//
//  Created by Edward Huang on 29/11/2018.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit

class UserProfileController: UIViewController {
    var user: User?
    var profileDataHandler: ProfileDataHandler!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = UIColor.white
        self.title = "Profile"
    
        profileDataHandler = ProfileDataHandler()
        profileDataHandler.getCurrentUser(onComplete: { (obtainedUser) in
            self.user = obtainedUser
        }, onError: {
            print("Could not obtained user data for current user\n")
        })
    }
}
