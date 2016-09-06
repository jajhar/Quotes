//
//  RegisterAPI.swift
//  Quotes
//
//  Created by James Ajhar on 9/5/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class RegisterAPI: APICommunication {
    
    internal func registerUser(username: String, password: String, completion: CompletionBlock, failure: (NSURLResponse?, NSError?, String?) -> Void) {
        
        super.sendRequestWithURL(URLs.registerUser(),
                                 requestType: RequestType.POST
            , parameters: ["username": username, "password": password],
              completion: { (json) -> Void in
                
                guard let json = json else {
                    print("Login response json is nil")
                    failure(nil, nil, nil)
                    return
                }
                
                guard let rawUser = json["user"] as? JSONDictionary else {
                    let message = json["errorMessage"] as? String
                    failure(nil, nil, message)
                    return
                }
                
                guard let user = UserDataManager.CreateUserWithJSON(rawUser, inManagedObjectContext: CoreDataManager.managedObjectContext) else {
                    print("Login response is missing Data key")
                    failure(nil, nil, nil)
                    return
                }
                
                guard let token = json["token"] as? String else {
                    print("Login response is missing token key")
                    failure(nil, nil, nil)
                    return
                }
                
                // update local session
                AppData.sharedInstance.storeLocalSession(token, user: user)
                completion(user)
                
        }) { (response, error) -> Void in
            print("ERROR: %@", error)
            failure(response, error, nil)
        }
    }
    
}