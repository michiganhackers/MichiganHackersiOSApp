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

// Google Calendar/General ViewController stuff
class EventController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    private let service = GTLRCalendarService()
    
    private let scopes = [kGTLRAuthScopeCalendarReadonly]
    
    private var eventList = [Event]()
    
    lazy var noEvents: UITextView = {
        let noEvents = UITextView()
        noEvents.frame = view.bounds
        noEvents.isEditable = false
        noEvents.isHidden = true
        return noEvents
    }()
    
    func setupNoEvents() {
        noEvents.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noEvents.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    lazy var signInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        //button.frame = CGRect(x: view.frame.midX - 70, y: view.frame.midY - 25, width: 130, height: 50)
        return button
    }()
    
    lazy var signInText: UILabel = {
        let text = UILabel()
        text.font = Ultramagnetic(size: 18)
        text.text = "Please sign in to any Google account."
        text.textAlignment = .center
        text.numberOfLines = 2
        text.frame = CGRect(x: view.frame.midX - 105, y: view.frame.midY - 175, width: 200, height: 200)
        return text
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [signInText, signInButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func setupSignInStackView() {
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: false))
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        //GIDSignIn.sharedInstance().signInSilently()
        
        view.addSubview(stackView)
        setupSignInStackView()
        
        view.addSubview(noEvents)
        setupNoEvents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.signInText.isHidden = true
            self.noEvents.isHidden = true
            self.stackView.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchEvents()
        }
    }
    
    // Get the list of events from the calendar
    func fetchEvents() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "8n8u58ssric1hmm84jvkvl9d68@group.calendar.google.com")
        query.maxResults = 10
        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(query, delegate: self, didFinish: #selector(storeEvents(ticket:finishedWithObject:error:)))
    }
    
    // Store the events to be shown
    @objc func storeEvents(ticket: GTLRServiceTicket, finishedWithObject response: GTLRCalendar_Events, error: NSError?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        // Get the events, create Event objects and store them in the array
        if let events = response.items, !events.isEmpty {
            for event in events {
                let start = event.start!.dateTime ?? event.start!.date!
                guard let title = event.summary, let location = event.location else {return}
                let eventObj = Event(title: title, date: DateFormatter.localizedString(from: start.date, dateStyle: .short, timeStyle: .short), location: location)
                eventList.append(eventObj)
            }
        } else {
            noEvents.text = "No upcoming events found."
        }
        
        adapter.collectionView = self.collectionView
        adapter.dataSource = self
    }
}

// ListKit stuff
extension EventController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var items = [ListDiffable]()
        items += eventList as [ListDiffable]
        
//        return items.sorted(by: { (left: Any, right: Any) -> Bool in
//            if let left = left as? DateSortable, let right = right as? DateSortable {
//                return left.date > right.date
//            }
//            return false
//        })
        return items
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return EventSectionController()
        // Add in more section controllers here if needed
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        print("EMPTY VIEW")
        return nil
    }
}





