//
//  Projects+CoreDataProperties.swift
//  kanbanv2
//
//  Created by Ryan on 2018-10-26.
//  Copyright © 2018 Ryan. All rights reserved.
//
//

import Foundation
import CoreData


extension Projects {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Projects> {
        return NSFetchRequest<Projects>(entityName: "Projects")
    }

    @NSManaged public var name: String?

}
