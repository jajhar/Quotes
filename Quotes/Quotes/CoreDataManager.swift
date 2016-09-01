//
//  CoreDataManager.swift
//  Quotes
//
//  Created by James Ajhar on 8/29/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataManager {
    
    static let CoreDataNotificationQuotesPurged = "CoreDataNotificationQuotesPurged"
    
    static private(set) var managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    static private(set) var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.persistentStoreCoordinator
    }()
}