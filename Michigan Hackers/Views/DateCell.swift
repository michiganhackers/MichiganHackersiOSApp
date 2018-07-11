//
//  MonthCell.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 6/19/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateCell: JTAppleCell {
    lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.textColor = UIColor.white
        date.textAlignment = .center
        date.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        return date
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    func setupSubviews() {
        contentView.addSubview(dateLabel)
        
        // Date constraints
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
