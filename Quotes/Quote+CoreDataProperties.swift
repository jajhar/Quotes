//
//  Quote+CoreDataProperties.swift
//  
//
//  Created by James Ajhar on 9/9/16.
//
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
    @NSManaged var heardBy: NSSet?
    @NSManaged var owner: NSManagedObject?
    @NSManaged var saidBy: User?
    @NSManaged var usernameTags: NSSet?

}
