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

    var rawCreateTimeString: String?
    var convertedDateString: String?
    
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
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MM/dd/yy"
                self.convertedDateString = formatter.stringFromDate(date)
            }
        }
        
        if let text = json["text"] as? String {
            self.text = text
        }
        
        if let createDate = json["createdAt"] as? String {
            self.rawCreateTimeString = createDate
        }
        
        if let ownerInfo = json["owner"] as? JSONDictionary {
            self.owner = UserDataManager.CreateUserWithJSON(ownerInfo, inManagedObjectContext: CoreDataManager.managedObjectContext)
        }
    }

}
