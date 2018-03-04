//
//  EventSectionController.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 2/25/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import UIKit
import IGListKit

class EventCollectionViewCell: UICollectionViewCell {
    let hello = "Hello"
}

class EventSectionController: ListSectionController {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 55)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: EventCollectionViewCell.self, for: self, at: index)
    }
}
