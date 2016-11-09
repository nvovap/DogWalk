//
//  Walk+CoreDataProperties.swift
//  DogWalk
//
//  Created by Vladimir Nevinniy on 11/9/16.
//  Copyright © 2016 Vladimir Nevinniy. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var dog: Dog?

}
