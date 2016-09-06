//
//  LoginAPI.swift
//  Quotes
//
//  Created by James Ajhar on 9/5/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class PKAPILogin: APICommunication {
    
    internal func loginUser(username: String, password: String, completion: (User?) -> Void, failure: FailureBlock) {
        
        super.sendRequestWithURL(URLs.loginUser(),
                                 requestType: RequestType.POST
            , parameters: ["username": username, "password": password],
              completion: { (json) -> Void in
                
                guard let json = json else {
                    print("Login response json is nil")
                    failure(nil, nil)
                    return
                }
                
                guard let responseData = json["data"] as? JSONDictionary else {
                    print("Login response is missing data key")
                    failure(nil, nil)
                    return
                }
                
                guard let rawUser = responseData["user"] as? JSONDictionary else {
                    print("Login response is missing user key")
                    failure(nil, nil)
                    return
                }
                
                guard let token = responseData["token"] as? String else {
                    print("Login response is missing token key")
                    failure(nil, nil)
                    return
                }
                
                guard let user = UserDataManager.CreateUserWithJSON(rawUser, inManagedObjectContext: CoreDataManager.managedObjectContext) else {
                    print("Login response is missing user key")
                    failure(nil, nil)
                    return
                }
                
                AppData.sharedInstance.storeLocalSession(token, user: user)
                completion(user)
                
        }) { (response, error) -> Void in
            print("ERROR: %@", error)
            failure(response, error)
        }
    }
}