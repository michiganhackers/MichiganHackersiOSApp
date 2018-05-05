//
//  SignInController.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 5/1/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class SignInController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    private let service = GTLRCalendarService()
    
    private let scopes = [kGTLRAuthScopeCalendarReadonly]
    
    let signInButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        view.addSubview(signInButton)
        signInButton.frame = CGRect(x: (view.frame.width / 2) - 50, y: (view.frame.height / 2) - 25, width: 100, height: 50)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
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
}
