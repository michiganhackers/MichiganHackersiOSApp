//
//  EventCell.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 4/20/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    let title: UILabel = {
        let title = UILabel()
        title.backgroundColor = UIColor.clear
        title.textColor = UIColor.white
        
        let font = Ultramagnetic(size: 18)
        // Allow for the user to scale the font
        if #available(iOS 11.0, *) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            title.font = metrics.scaledFont(for: font)
        } else {
            title.font = font
        }
        
        title.textAlignment = .left
        return title
    }()
    
    let date: UILabel = {
        let date = UILabel()
        date.backgroundColor = UIColor.clear
        date.textColor = UIColor.white
        
        let font = Ultramagnetic(size: 14)
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
    
    let location: UILabel = {
        let location = UILabel()
        location.backgroundColor = UIColor.clear
        location.textColor = UIColor.white
        
        let font = Ultramagnetic(size: 14)
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
    
    let details: UILabel = {
        let deets = UILabel()
        deets.backgroundColor = UIColor.clear
        deets.textColor = UIColor.white
        
        let font = Ultramagnetic(size: 10)
        // Allow for the user to scale the font
        if #available(iOS 11.0, *) {
            let metrics = UIFontMetrics(forTextStyle: .body)
            deets.font = metrics.scaledFont(for: font)
        } else {
            deets.font = font
        }
        
        deets.textAlignment = .left
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset = UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15))
        title.frame = inset
        date.frame = inset
        location.frame = inset
        details.frame = inset
    }
    
    func setupContentViewComponents() {
        contentView.addSubview(title)
        contentView.addSubview(date)
        contentView.addSubview(location)
        contentView.addSubview(details)
        
        // Title constraints
        title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15)
        title.bottomAnchor.constraint(equalTo: date.topAnchor, constant: 10)
        
        // Date constraints
        date.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10)
        date.bottomAnchor.constraint(equalTo: location.topAnchor, constant: 10)
        
        // Location constraints
        location.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 10)
        location.bottomAnchor.constraint(equalTo: details.topAnchor, constant: 10)
        
        // Details constraints
        details.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10)
        details.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 15)
        
    }
    
    
    
    
    
}
