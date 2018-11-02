//
//  CalendarController.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 2/22/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit
import JTAppleCalendar
import IGListKit
import GoogleAPIClientForREST
import GoogleSignIn

class CalendarController: UIViewController {
    private let service = GTLRCalendarService()
    private let calendar = Calendar(identifier: .gregorian)
    private var selectedDate: Date? = nil
    
    let calCellID = "CalendarCell"
    let todaysDate = Date()
    var calendarEvents: EventCollection = EventCollection()
    
    lazy var orangeView: UIView = {
        let orange = UIView()
        orange.backgroundColor = UIColor(hexString: "F15D24")
        orange.frame = CGRect(x: 0, y: 0, width: view.frame.width,
                              height: view.frame.height * 5/9)
        return orange
    }()
    
    // dailyEventsView is the view in which all the events on the selected day
    // are displayed. It is filled using data requested from Google Calendar.
    // Data is requested for an entire month when that month is viewed.
    lazy var dailyEventsView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let dailyEvents = UICollectionView(frame: .zero,
                                           collectionViewLayout: layout)
        dailyEvents.backgroundColor = UIColor.white
        dailyEvents.translatesAutoresizingMaskIntoConstraints = false
        return dailyEvents
    }()
    
    lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = dailyEventsView
        adapter.dataSource = self   
        return adapter
    }()
    
    let formatter: DateFormatter = {
        let form = DateFormatter()
        form.dateFormat = "yyyy MM dd"
        form.timeZone = Calendar.current.timeZone
        form.locale = Calendar.current.locale
        return form
    }()
    
    lazy var dateStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [monthLabel, yearLabel])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.frame = CGRect(x: 15, y: 10, width: view.frame.width, height: view.frame.height)
        return stack
    }()
    
    lazy var weekStack: UIStackView = {
        let week = UIStackView(arrangedSubviews: [getDayOfTheWeek(day: "SUN"), getDayOfTheWeek(day: "MON"), getDayOfTheWeek(day: "TUES"), getDayOfTheWeek(day: "WED"), getDayOfTheWeek(day: "THURS"), getDayOfTheWeek(day: "FRI"), getDayOfTheWeek(day: "SAT")])
        week.axis = .horizontal
        week.distribution = .fillEqually
        week.translatesAutoresizingMaskIntoConstraints = false
        week.frame = CGRect(x: 15, y: 100, width: view.frame.width, height: view.frame.height)
        return week
    }()
    
    lazy var monthLabel: UILabel = {
        let month = UILabel()
        
        let font = Ultramagnetic(size: 32)
        // Allow for the user to scale the font
        if #available(iOS 11.0, *) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            month.font = metrics.scaledFont(for: font)
        } else {
            month.font = font
        }
        month.textAlignment = .left
        month.textColor = UIColor.white
        month.sizeToFit()
        return month
    }()
    
    lazy var yearLabel: UILabel = {
        let year = UILabel()
        
        let font = Ultramagnetic(size: 32)
        // Allow for the user to scale the font
        if #available(iOS 11.0, *) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            year.font = metrics.scaledFont(for: font)
        } else {
            year.font = font
        }
        year.textAlignment = .left
        year.textColor = UIColor.white
        year.sizeToFit()
        return year
    }()
    
    lazy var collectionView: JTAppleCalendarView = {
        let col = JTAppleCalendarView()
        col.backgroundColor = UIColor.clear
        col.isPagingEnabled = true
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.scrollDirection = .horizontal
        col.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height * 5/9)
        return col
    }()
    
    // Helper for showing an alert. Useful for displaying error messages.
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
    
    // Get the list of events from the calendar for an entire month. The
    // parameter dateInMonth can be any date within the desired month.
    func fetchEventsForMonth(dateInMonth: Date) {
        let monthYearSet: Set<Calendar.Component> = [.month, .year]
        let components = calendar.dateComponents(monthYearSet, from: dateInMonth)
        let monthBeginning = calendar.date(from: components)!
        let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthBeginning)!
        fetchEvents(startDay: monthBeginning, endDay: monthEnd)
    }
    
    // Get the list of events from the calendar for a specified date range. Note
    // that only events from 12:00am on startDay until 12:00am on endDay are
    // included (i.e. the events on endDay are *not* fetched).
    func fetchEvents(startDay: Date, endDay: Date) {
        let startDay = calendar.startOfDay(for: startDay)
        let endDay = calendar.startOfDay(for: endDay)
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId:
            "8n8u58ssric1hmm84jvkvl9d68@group.calendar.google.com")
        query.maxResults = 200
        query.timeMin = GTLRDateTime(date: startDay)
        query.timeMax = GTLRDateTime(date: endDay)
        query.singleEvents = true
        query.orderBy = kGTLRCalendarOrderByStartTime
        service.executeQuery(query, delegate: self, didFinish: #selector(
            storeEvents(ticket:finishedWithObject:error:)))
    }
    
    // Store the events to be shown
    @objc func storeEvents(ticket: GTLRServiceTicket,finishedWithObject response: GTLRCalendar_Events, error: NSError?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        // Get the events, create Event objects and store them in the array
        if let events = response.items, !events.isEmpty {
            for event in events {
                let start = event.start!.dateTime ?? event.start!.date!
                guard let title = event.summary else { continue }
                let location = event.location ?? ""
                let details = event.descriptionProperty ?? ""
                let eventObj = Event(title: title, date: DateFormatter.localizedString(from: start.date, dateStyle: .short, timeStyle: .short), location: location, details: details)
                
                calendarEvents.addEvent(date: start.date, event: eventObj)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupViews()
        
        // Assume the user is already signed in from the EventController.
        // If this authentication is available, use it for making calendar requests.
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            if let auth = user.authentication.fetcherAuthorizer() {
                service.authorizer = auth
            }
        }
    }
    
    func setupViews() {
        edgesForExtendedLayout = []
        view.addSubview(orangeView)
        orangeView.addSubview(collectionView)
        orangeView.addSubview(dateStack)
        orangeView.addSubview(weekStack)
        view.addSubview(dailyEventsView)
        
        weekStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        weekStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        weekStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
        
        dailyEventsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dailyEventsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dailyEventsView.topAnchor.constraint(equalTo: orangeView.bottomAnchor, constant: 15).isActive = true
        dailyEventsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: calCellID)
        
        collectionView.visibleDates { dateSegment in
            self.initializeCalendar(dateSegment: dateSegment)
        }
        
        collectionView.calendarDataSource = self
        collectionView.calendarDelegate = self
        collectionView.scrollToDate(Date(), animateScroll: false)
        collectionView.selectDates([Date()])
    }
    
    func getDayOfTheWeek(day: String) -> UILabel {
        let label = UILabel()
        label.text = day
        
        let font = Ultramagnetic(size: 14)
        // Allow for the user to scale the font
        if #available(iOS 11.0, *) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            label.font = metrics.scaledFont(for: font)
        } else {
            label.font = font
        }
        
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.sizeToFit()
        
        return label
    }
}

// JTAppleCalendar stuff
extension CalendarController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calCellID, for: indexPath) as! DateCell
        cell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calCellID, for: indexPath) as! DateCell
        cell.dateLabel.text = cellState.text
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        guard let startDate = formatter.date(from: "2018 01 01") else {return ConfigurationParameters(startDate: Date(), endDate: Date())}
        let parameter = ConfigurationParameters(startDate: startDate, endDate: Date())
        return parameter
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
        
        // When a cell is selected, update the selectedDate property and update
        // the list of events at the bottom of the screen.
        selectedDate = date
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        initializeCalendar(dateSegment: visibleDates)
        fetchEventsForMonth(dateInMonth: visibleDates.monthDates[0].date)
    }
    
    func initializeCalendar(dateSegment: DateSegmentInfo) {
        guard let date = dateSegment.monthDates.first?.date else {return}
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
    }
    
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let dateCell = cell as? DateCell else {return}
        
        handleCellTextColor(cell: dateCell, cellState: cellState)
        handleCellVisibility(cell: dateCell, cellState: cellState)
        handleCellSelection(cell: dateCell, cellState: cellState)
        handleCellEvents(cell: dateCell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        
        formatter.dateFormat = "yyyy MM dd"
        
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        if todaysDateString == monthDateString {
            cell.dateLabel.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
        } else {
            cell.dateLabel.textColor = cellState.isSelected ? UIColor(hexString: "F15D24") : UIColor.white
            cell.backgroundColor = cellState.isSelected ? UIColor.white : UIColor(hexString: "F15D24")
        }
    }
    
    func handleCellVisibility(cell: DateCell, cellState: CellState) {
        cell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
    }
    
    func handleCellSelection(cell: DateCell, cellState: CellState) {
        cell.selectedBackgroundView?.isHidden = cellState.isSelected ? false : true
    }
    
    func handleCellEvents(cell: DateCell, cellState: CellState) {
        cell.dotView.isHidden = !calendarEvents.hasEvents(date: cellState.date)
    }
}

// For ListKit
extension CalendarController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        if let selectedDate = selectedDate {
            return calendarEvents.getEvents(date: selectedDate)
        }
        return []
    }
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return EventSectionController()
    }
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
