//
//  EventCell.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 4/20/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [title, date, location, details])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.backgroundColor = UIColor.clear
        title.textColor = UIColor.white
        
        let font = Ultramagnetic(size: 24)
        // Allow for the user to scale the font
        if #available(iOS 11.0, *) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            title.font = metrics.scaledFont(for: font)
        } else {
            title.font = font
        }
        
        //title.frame = CGRect(x: contentView.frame.midX, y: 15, width: contentView.frame.width - 30, height: 14)
        title.textAlignment = .left
        return title
    }()
    
    lazy var date: UILabel = {
        let date = UILabel()
        date.backgroundColor = UIColor.clear
        date.textColor = UIColor.white
        
        let font = Ultramagnetic(size: 18)
        // Allow for the user to scale the font
        if #available(iOS 11.0, *) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            date.font = metrics.scaledFont(for: font)
        } else {
            date.font = font
        }
        
        date.textAlignment = .left
        return date
    }()
    
    lazy var location: UILabel = {
        let location = UILabel()
        location.backgroundColor = UIColor.clear
        location.textColor = UIColor.white
        
        let font = Ultramagnetic(size: 18)
        // Allow for the user to scale the font
        if #available(iOS 11.0, *) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            location.font = metrics.scaledFont(for: font)
        } else {
            location.font = font
        }
        
        location.textAlignment = .left
        return location
    }()
    
    lazy var details: UILabel = {
        let deets = UILabel()
        deets.backgroundColor = UIColor.clear
        deets.textColor = UIColor.white
        
        let font = Ultramagnetic(size: 12)
        // Allow for the user to scale the font
        if #available(iOS 11.0, *) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            deets.font = metrics.scaledFont(for: font)
        } else {
            deets.font = font
        }
        
        deets.textAlignment = .left
        deets.numberOfLines = 5
        return deets
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentViewComponents()
        contentView.backgroundColor = UIColor(hexString: "F15D24")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentViewComponents() {
        contentView.addSubview(infoStack)
        
        infoStack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15)
        infoStack.isLayoutMarginsRelativeArrangement = true
        
        
        // Title constraints
        title.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: date.topAnchor, constant: 10).isActive = true

        // Date constraints
        date.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        date.bottomAnchor.constraint(equalTo: location.topAnchor, constant: 10).isActive = true

        // Location constraints
        location.topAnchor.constraint(equalTo: date.bottomAnchor).isActive = true
        location.bottomAnchor.constraint(equalTo: details.topAnchor, constant: 10).isActive = true

        // Details constraints
        details.topAnchor.constraint(equalTo: location.bottomAnchor).isActive = true
        details.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 15).isActive = true
        details.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1/3).isActive = true
        details.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        
    }
}
