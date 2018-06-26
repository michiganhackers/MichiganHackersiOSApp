//
//  MonthCell.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 6/19/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit
import JTAppleCalendar

class MonthCell: JTAppleCell {
    lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.frame = CGRect(x: frame.midX, y: frame.midY, width: frame.width, height: frame.height)
        
        return date
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
