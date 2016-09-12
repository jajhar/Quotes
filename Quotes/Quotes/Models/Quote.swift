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
    
    convenience init(text: String) {
        let entity = NSEntityDescription.entityForName("Quote", inManagedObjectContext: CoreDataManager.managedObjectContext)!
        self.init(entity: entity, insertIntoManagedObjectContext: nil)
        self.text = text
    }
    
    override func supplyJSONDictionary(json: JSONDictionary) {
        super.supplyJSONDictionary(json)
        
        if let id = json["id"] as? String {
            self.id = id
            
            // Get time created in proper format "n ago"
            let index: String.Index = id.startIndex.advancedBy(8) // Swift 2
            let objectId:String = id.substringToIndex(index) // "Stack"
            var result: UInt64 = 0
            let success :Bool = NSScanner(string: objectId).scanHexLongLong(&result)
            if success {
                let date = NSDate(timeIntervalSince1970: Double(result))
                self.createdAt = date
            }
        }
        
        if let text = json["text"] as? String {
            self.text = text
        }

        if let createDate = json["createdAt"] as? String {
            self.rawCreateTimeString = createDate
        }
        
        if let rawSaidDate = json["saidDate"] as? Int {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            let date = NSDate(timeIntervalSince1970: Double(rawSaidDate))
            convertedDateString = formatter.stringFromDate(date)
        }
        
        if let ownerInfo = json["owner"] as? JSONDictionary {
            self.owner = UserDataManager.CreateUserWithJSON(ownerInfo,
                                                            inManagedObjectContext: CoreDataManager.managedObjectContext)
        }
        
        if let rawTags = json["usernameTags"] as? [String] {
            
            var tags = [UsernameTags]()
            
            for tag in rawTags {
                if let newTag = UserDataManager.CreateUsernameTagWithString(tag,
                                                                          inManagedObjectContext: CoreDataManager.managedObjectContext) {
                    tags.append(newTag)
                }
            }
            
            usernameTags = NSSet(array: tags)

        }
        
        if let heardByArray = json["heardBy"] as? [JSONDictionary] {
            var users = [User]()
            for rawUserInfo in heardByArray {
                if let user = UserDataManager.CreateUserWithJSON(rawUserInfo,
                                                                 inManagedObjectContext: CoreDataManager.managedObjectContext) {
                    users.append(user)
                }
            }
            heardBy = NSSet(array: users)
        }
        
        if let rawUserInfo = json["saidBy"] as? JSONDictionary {
            if let user = UserDataManager.CreateUserWithJSON(rawUserInfo,
                                                             inManagedObjectContext: CoreDataManager.managedObjectContext) {
                saidBy = user
            }
        }

    }

}
