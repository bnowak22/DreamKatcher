//
//  Dream.swift
//  DreamKatcher2
//
//  Created by bnowak on 9/29/14.
//  Copyright (c) 2014 bnowak. All rights reserved.
//

import Foundation
import CoreData

@objc(Dream)
class Dream: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var text: String
    @NSManaged var tags: String
    @NSManaged var date: String
    @NSManaged var lucid: Bool
    
}
