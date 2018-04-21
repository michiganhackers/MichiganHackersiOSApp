//
//  EventController.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 2/1/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit
import IGListKit
import GoogleAPIClientForREST
import GoogleSignIn

class EventController: UIViewController {
    
    private let service = GTLRCalendarService()
    
    private let scopes = [kGTLRAuthScopeCalendarReadonly]
    
    private var eventList = [Event]()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        //GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        view.addSubview(collectionView)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
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

// ListKit stuff
extension EventController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return eventList.sorted(by: { (left: Event, right: Event) -> Bool in
            if let left = left as? DateSortable, let right = right as? DateSortable {
                return left.date < right.date
            }
            return false
        }) as! [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return EventSectionController()
        // Add in more section controllers here if needed
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

// GoogleCal stuff
extension EventController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    // Get the list of events from the calendar
    func fetchEvents() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.maxResults = 10
        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(query, delegate: self, didFinish: #selector(storeEvents(ticket:finishedWithObject:error:)))
    }
    
    // Show the events
    @objc func storeEvents(ticket: GTLRServiceTicket, finishedWithObject response: GTLRCalendar_Events, error: NSError?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        // Get the events, create Event objects and store them in the array
        if let events = response.items {
            for event in events {
                let start = event.start!.dateTime ?? event.start!.date!
                let eventObj = Event()
                eventObj.date = DateFormatter.localizedString(from: start.date, dateStyle: .short, timeStyle: .short)
                eventObj.title = event.summary
                eventObj.location = event.location
                eventList.append(eventObj)
            }
        } else {
            let noEvents = UITextView()
            noEvents.text = "No upcoming events found."
            noEvents.frame = view.bounds
            noEvents.widthAnchor.constraint(equalTo: view.widthAnchor)
            noEvents.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(noEvents)
        }
    }
}





