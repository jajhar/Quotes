//
//  Quote+CoreDataProperties.swift
//  Quotes
//
//  Created by James Ajhar on 9/11/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Quote {

    @NSManaged var createdAt: NSDate?
    @NSManaged var id: String?
    @NSManaged var ownerId: String?
    @NSManaged var text: String?
    @NSManaged var rawCreateTimeString: String?
    @NSManaged var convertedDateString: String?
    @NSManaged var heardBy: NSSet?
    @NSManaged var owner: User?
    @NSManaged var saidBy: User?
    @NSManaged var usernameTags: NSSet?

}
