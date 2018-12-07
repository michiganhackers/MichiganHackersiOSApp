//
//  UserProfileController.swift
//  Michigan Hackers
//
//  Created by Edward Huang on 29/11/2018.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit

 var profilePic = UIImageView()

class UserProfileController: UIViewController {
    
    var viewOfImage = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = UIColor.white
        self.title = "Profile"
        setupProfileFields()
    }
    
    func setupProfileFields() {
        viewOfImage.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = 20
        //profilePic.layer.masksToBounds = true
        //viewOfImage.layer.masksToBounds = true
        //profilePic.layer.cornerRadius = 5
        profilePic.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        //viewOfImage.addSubview(profilePic)
        self.view.addSubview(profilePic)
    }
    
}
