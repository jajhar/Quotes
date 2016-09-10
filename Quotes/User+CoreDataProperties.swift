//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var avatarURL: String?
    @NSManaged var id: String?
    @NSManaged var username: String?
    @NSManaged var quotes: NSSet?

}
