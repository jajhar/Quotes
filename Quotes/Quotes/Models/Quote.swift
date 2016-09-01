//
//  Quote.swift
//  
//
//  Created by James Ajhar on 8/29/16.
//
//

import Foundation
import CoreData


class Quote: ModelObject {

    override func supplyJSONDictionary(json: JSONDictionary) {
        super.supplyJSONDictionary(json)
        
        if let id = json["id"] as? String {
            self.id = id
        }

        if let text = json["text"] as? String {
            self.text = text
        }
        
        if let ownerInfo = json["owner"] as? JSONDictionary {
            self.owner = User.UserWithJSON(ownerInfo, inManagedObjectContext: CoreDataManager.managedObjectContext)
        }
    }
    
    class func QuoteWithJSON(json: JSONDictionary, inManagedObjectContext context: NSManagedObjectContext) -> Quote? {
        
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
    
    class func DeleteAllQuotes(inContext context: NSManagedObjectContext) {
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

}
