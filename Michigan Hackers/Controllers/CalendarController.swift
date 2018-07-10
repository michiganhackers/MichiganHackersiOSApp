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
    lazy var orangeView: UIView = {
        let orange = UIView()
        orange.backgroundColor = UIColor(hexString: "F15D24")
        orange.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 5/9)
        return orange
    }()
    
    let formatter: DateFormatter = {
        let form = DateFormatter()
        form.dateFormat = "yyyy MM dd"
        form.timeZone = Calendar.current.timeZone
        form.locale = Calendar.current.locale
        return form
    }()
    
    let calCellID = "CalendarCell"
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupViews()
    }
    
    func setupViews() {
        edgesForExtendedLayout = []
        view.addSubview(orangeView)
        orangeView.addSubview(collectionView)
        orangeView.addSubview(dateStack)
        orangeView.addSubview(weekStack)
        
        weekStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        weekStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        weekStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
        
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: calCellID)
        
        collectionView.visibleDates { (dateSegment) in
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
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        if let startDate = formatter.date(from: "2018 01 01"), let endDate = formatter.date(from: "2018 12 31") {
            let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
            return parameters
        } else {
            return ConfigurationParameters(startDate: Date(), endDate: Date())
        }
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
        
        //handleCellTextColor()
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        
    }
    
    
}





