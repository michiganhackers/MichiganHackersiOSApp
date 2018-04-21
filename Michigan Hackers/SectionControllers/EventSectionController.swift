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
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        
        return CGSize(width: context.containerSize.width, height: 200)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: Event.self, for: self, at: index)
    }
}
