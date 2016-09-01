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
    
}
