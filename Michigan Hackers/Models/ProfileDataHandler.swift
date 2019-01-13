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
    
    override init() {
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        membersRef = db.collection("Members")
    }
    
    func getCurrentUserDictionary(onComplete: @escaping ([String: Any]) -> Void,
                                  onError:    @escaping () -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            onError()
            return
        }
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
            guard let uid = Auth.auth().currentUser?.uid else {
                onError()
                return
            }
            onComplete(User(bio: bio, majors: majors, name: name, teams: teams,
                            title: title, uid: uid, year: year))
        }, onError: onError)
    }
}
