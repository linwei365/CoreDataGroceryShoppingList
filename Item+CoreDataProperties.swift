//
//  Item+CoreDataProperties.swift
//  CoreDataGroceryList
//
//  Created by Lin Wei on 2/1/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var image: NSData?
    @NSManaged var name: String?
    @NSManaged var note: String?
    @NSManaged var quantity: String?

}
