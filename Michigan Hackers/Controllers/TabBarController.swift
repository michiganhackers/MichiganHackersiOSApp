//
//  TabBarController.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 3/15/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the tab bar
        let events = EventController()
        events.tabBarItem = UITabBarItem(title: "Events", image: #imageLiteral(resourceName: "icons8-reminder-50"), tag: 0)
        
        let calendar = CalendarController()
        calendar.tabBarItem = UITabBarItem(title: "Calendar", image: #imageLiteral(resourceName: "icons8-calendar-50"), tag: 1)
        
        let notifications = NotificationController()
        notifications.tabBarItem = UITabBarItem(title: "Notifications", image: #imageLiteral(resourceName: "icons8-alarm-50"), tag: 2)
        
        let resources = ResourcesController()
        resources.tabBarItem = UITabBarItem(title: "Resources", image: #imageLiteral(resourceName: "icons8-book-50"), tag: 3)
        
        let controllers = [events, calendar, notifications, resources]
        viewControllers = controllers.map {UINavigationController(rootViewController: $0) }
    }
}
