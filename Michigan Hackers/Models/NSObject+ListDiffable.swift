//
//  NSObject+ListDiffable.swift
//  Michigan Hackers
//
//  Created by Connor Svrcek on 5/29/18.
//  Copyright © 2018 Connor Svrcek. All rights reserved.
//

import Foundation
import IGListKit

extension NSObject: ListDiffable {
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
    
    
}
