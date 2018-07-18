//
//  EventSectionController.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 3/29/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit
import IGListKit

class EventSectionController: ListSectionController {
    var event: Event!
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        
        return CGSize(width: context.containerSize.width - 30, height: 200)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: EventCell.self, for: self, at: index) as! EventCell
        cell.title.text = event.title
        cell.date.text = event.date
        cell.location.text = event.location
        cell.details.text = event.details
        
        // Adding rounded corners
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        // Adding shadow
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
    override func didUpdate(to object: Any) {
        event = object as? Event
    }
    
    override func didSelectItem(at index: Int) {
        // TODO: send to google calendar when clicked on?
    }
}
