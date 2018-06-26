//
//  CalendarController.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 2/22/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarController: UIViewController {
    let formatter: DateFormatter = {
        let form = DateFormatter()
        form.dateFormat = "MM dd yyy"
        form.timeZone = Calendar.current.timeZone
        form.locale = Calendar.current.locale
        return form
    }()
    
    let calCellID = "CalendarCell"
    
    lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.text = "June 2018"
        
        let font = Ultramagnetic(size: 32)
        // Allow for the user to scale the font
        if #available(iOS 11.0, *) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            date.font = metrics.scaledFont(for: font)
        } else {
            date.font = font
        }
        date.textAlignment = .left
        date.textColor = UIColor.white
        date.frame = CGRect(x: 15, y: 10, width: 100, height: 20)
        date.sizeToFit()
        return date
    }()
    
    lazy var collectionView: JTAppleCalendarView = {
        let col = JTAppleCalendarView()
        col.backgroundColor = UIColor(hexString: "F15D24")
        col.isPagingEnabled = true
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.scrollDirection = .horizontal
        col.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 5/9)
        return col
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        edgesForExtendedLayout = []
        view.addSubview(collectionView)
        view.addSubview(dateLabel)
        collectionView.register(MonthCell.self, forCellWithReuseIdentifier: calCellID)
    }
}

// JTAppleCalendar stuff
extension CalendarController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calCellID, for: indexPath) as! MonthCell
        cell.dateLabel.text = cellState.text
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calCellID, for: indexPath) as! MonthCell
        cell.dateLabel.text = cellState.text
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        if let startDate = formatter.date(from: "01 01 2018"), let endDate = formatter.date(from: "12 31 2018") {
            let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
            return parameters
        } else {
            return ConfigurationParameters(startDate: Date(), endDate: Date())
        }
    }
    
    
}





