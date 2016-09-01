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

struct QuotesDataManager {
    
    static func DeleteAllQuotes(inContext context: NSManagedObjectContext) {
        //        let fetchRequest = NSFetchRequest(entityName: "Quote")
        //        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        //
        //        do {
        //            try context.executeRequest(deleteRequest)
        //            try CoreDataManager.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: context)
        //            try context.save()
        //        } catch let error as NSError {
        //            print("Could not clear \(error), \(error.userInfo)")
        //        }
        
        do {
            let fetchRequest = NSFetchRequest(entityName: "Quote")
            let results = try CoreDataManager.managedObjectContext.executeFetchRequest(fetchRequest) as? [Quote]
            
            for obj in results! {
                CoreDataManager.managedObjectContext.deleteObject(obj)
            }
            
            try CoreDataManager.managedObjectContext.save()
        } catch let error {
            print(error)
        }
    }
    
    static func CreateQuoteWithJSON(json: JSONDictionary, inManagedObjectContext context: NSManagedObjectContext) -> Quote? {
        
        guard let objectId = json["id"] as? String else {
            print("Warning: json id for quote is not a string value")
            return nil
        }
        
        let request = NSFetchRequest(entityName: "Quote")
        request.predicate = NSPredicate(format: "id = %@", objectId)
        
        var quote: Quote?
        
        if let existingQuote = (try? context.executeFetchRequest(request))?.first as? Quote {
            quote = existingQuote
        } else if let newQuote = NSEntityDescription.insertNewObjectForEntityForName("Quote", inManagedObjectContext: context) as? Quote {
            quote = newQuote
        }
        
        guard let returnedQuote = quote else {
            return nil
        }
        
        returnedQuote.supplyJSONDictionary(json)
        
        do {
            try context.save()
        } catch let error {
            print("Error: Failed to save Quote \(returnedQuote.objectID) to Core Data: \(error)")
        }
        
        return returnedQuote
    }
}

struct UserDataManager {
    
    static func CreateUserWithJSON(json: JSONDictionary, inManagedObjectContext context: NSManagedObjectContext) -> User? {
        
        guard let objectId = json["id"] as? String else {
            print("Warning: json id for user is not a string value")
            return nil
        }
        
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "id = %@", objectId)
        
        var user: User?
        
        if let existingUser = (try? context.executeFetchRequest(request))?.first as? User {
            user = existingUser
        } else if let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as? User {
            user = newUser
        }
        
        guard let returnedUser = user else {
            return nil
        }
        
        returnedUser.supplyJSONDictionary(json)
        
        do {
            try context.save()
        } catch let error {
            print("Error: Failed to save User \(returnedUser.objectID) to Core Data: \(error)")
        }
        
        return returnedUser
    }
    
    static func DeleteAllUsers() {
        let fetchRequest = NSFetchRequest(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataManager.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: CoreDataManager.managedObjectContext)
        } catch let error as NSError {
            print("Could not clear \(error), \(error.userInfo)")
        }
    }
    
}