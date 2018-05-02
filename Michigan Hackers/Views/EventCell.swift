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
        title.font = Ultramagnetic(size: 18)
        title.textAlignment = .left
        return title
    }()
    
    let date: UILabel = {
        let date = UILabel()
        date.backgroundColor = UIColor.clear
        date.textColor = UIColor.white
        date.font = Ultramagnetic(size: 14)
        date.textAlignment = .left
        return date
    }()
    
    let location: UILabel = {
        let location = UILabel()
        location.backgroundColor = UIColor.clear
        location.textColor = UIColor.white
        location.font = Ultramagnetic(size: 14)
        location.textAlignment = .left
        return location
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(title)
        contentView.addSubview(date)
        contentView.addSubview(location)
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
    }
    
    
    
    
    
}
