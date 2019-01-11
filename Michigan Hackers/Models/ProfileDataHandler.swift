//
//  ProfileDataHandler.swift
//  Michigan Hackers
//
//  Created by Thomas Smith on 1/10/19.
//  Copyright © 2019 Connor Svrcek. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class ProfileDataHandler: NSObject {
    var membersRef: CollectionReference!
    var db: Firestore!
    
    let uid = "5KdXI9ppcsdsmcDvgBWJ5UI4MCz1" // TODO: This is a temporary hardcoding
    
    override init() {
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        membersRef = db.collection("Members")
    }
    
    func getCurrentUserDictionary(onComplete: @escaping ([String: Any]) -> Void,
                                  onError:    @escaping () -> Void) {
        let docRef = membersRef.document(uid)
        docRef.getDocument(completion: { (doc, err) in
            if let doc = doc, doc.exists, let data = doc.data() {
                onComplete(data)
            }
            else {
                onError()
            }
        })
    }
    
    func getCurrentUser(onComplete: @escaping (User) -> Void,
                                  onError:    @escaping () -> Void) {
        return getCurrentUserDictionary(onComplete: { (dict) in
            let bio = dict["bio"] as? String
            let majors = dict["majors"] as? [String] ?? []
            guard let name = dict["name"] as? String else {
                onError()
                return
            }
            let teams = dict["teams"] as? [String] ?? []
            let title = dict["title"] as? String
            guard let year = dict["year"] as? String else {
                onError()
                return
            }
            onComplete(User(bio: bio, majors: majors, name: name, teams: teams,
                            title: title, uid: self.uid, year: year))
        }, onError: onError)
    }
}
