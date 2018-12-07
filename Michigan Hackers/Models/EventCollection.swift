//
//  EventCollection.swift
//  Michigan Hackers
//
//  Created by Thomas Smith on 11/1/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import Foundation

// An EventCollection represents an arbitrary number of Event objects, each
// with a specified date. It provides an interface to add events, get all events
// on a given day, and check if a day has any events. Note that the day
// parameter in all methods must follow the format "yyyy MM dd".
class EventCollection: NSObject {
    private var eventsByDay: [String: [Event]] = [:]
    private var addedEventSets: Set<String> = []
    private let formatter: DateFormatter = {
        let form = DateFormatter()
        form.dateFormat = "yyyy MM dd"
        form.timeZone = Calendar.current.timeZone
        form.locale = Calendar.current.locale
        return form
    }()
    
    // Add a given event to a given day
    func addEvent(day: String, event: Event) {
        if eventsByDay[day] != nil {
            eventsByDay[day]!.append(event)
        }
        else {
            eventsByDay[day] = [event]
        }
    }
    
    func addEvent(date: Date, event: Event) {
        addEvent(day: formatter.string(from: date), event: event)
    }
    
    // Get an array of all events on a given day
    func getEvents(day: String) -> [Event] {
        if let eventList = eventsByDay[day] {
            return eventList
        }
        return []
    }
    
    func getEvents(date: Date) -> [Event] {
        return getEvents(day: formatter.string(from: date))
    }
    
    // Check whether a given day has any events
    func hasEvents(day: String) -> Bool {
        guard let dailyEvents = eventsByDay[day] else { return false }
        return dailyEvents.count != 0
    }
    
    func hasEvents(date: Date) -> Bool {
        return hasEvents(day: formatter.string(from: date))
    }
    
    // Mark a given set of events as added
    func addEventSet(_ name: String) {
        addedEventSets.insert(name)
    }
    
    // Check whether a given set of events has already been added
    func wasEventSetAdded(_ name: String) -> Bool {
        return addedEventSets.contains(name)
    }
}
