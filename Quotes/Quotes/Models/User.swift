//
//  User.swift
//  
//
//  Created by James Ajhar on 8/29/16.
//
//

import Foundation
import CoreData


class User: ModelObject {

    override func supplyJSONDictionary(json: JSONDictionary) {
        super.supplyJSONDictionary(json)
        
        if let id = json["id"] as? String {
            self.id = id
        }

        if let username = json["username"] as? String {
            self.username = username
        }
        
        if let avatarURL = json["avatar"] as? String {
            self.avatarURL = avatarURL
        }
    }
    
    func getUserAvatarURL() -> NSURL? {
        if avatarURL == nil {
            return nil
        }
        guard let url = NSURL(string: avatarURL!) else {
            return nil
        }
        return url
    }
    
    class func UserWithJSON(json: JSONDictionary, inManagedObjectContext context: NSManagedObjectContext) -> User? {
        
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
    
    func deleteAllUsers() {
        let fetchRequest = NSFetchRequest(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataManager.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: CoreDataManager.managedObjectContext)
        } catch let error as NSError {
            print("Could not clear \(error), \(error.userInfo)")
        }
    }

    
}
