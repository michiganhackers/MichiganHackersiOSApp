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

var eventList = [Event]()

// Google Calendar/General ViewController stuff
class EventController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    private let service = GTLRCalendarService()
    
    private let scopes = [kGTLRAuthScopeCalendarReadonly]
    
    private let refreshControl = UIRefreshControl()
    
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
        setupRefreshControl()
        
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
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
    
    // Setup the refreshControl
    func setupRefreshControl() {
        // Add Refresh Control to CollectionView
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        // Configure the refreshControl
        refreshControl.addTarget(self, action: #selector(fetchEvents), for: .valueChanged)

        // Style the refreshControl
        refreshControl.tintColor = UIColor(hexString: "F15D24")
    }
    
    // Sign users into Google account to load events
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
    @objc func fetchEvents() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "8n8u58ssric1hmm84jvkvl9d68@group.calendar.google.com")
        query.maxResults = 10
        query.timeMin = GTLRDateTime(date: Date())
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(query, delegate: self, didFinish: #selector(storeEvents(ticket:finishedWithObject:error:)))
        
        collectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    // Store the events to be shown
    @objc func storeEvents(ticket: GTLRServiceTicket, finishedWithObject response: GTLRCalendar_Events, error: NSError?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        // Get the events, create Event objects and store them in the array
        if let events = response.items, !events.isEmpty {
            // Empty string for description
            for event in events {
                let start = event.start!.dateTime ?? event.start!.date!
                // TODO: what if an event doesn't have a description?
                guard let title = event.summary, let location = event.location else {continue}
                let details = event.descriptionProperty ?? ""
                let eventObj = Event(title: title, date: DateFormatter.localizedString(from: start.date, dateStyle: .short, timeStyle: .short), location: location, details: details)
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





