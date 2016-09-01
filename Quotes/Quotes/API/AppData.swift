//
//  AppData.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation

import Foundation
import SSKeychain

class AppData {
    
    static let sharedInstance = AppData()
    weak var navigationManager : TabBarController!
    var localSession: LocalSession?
    
    init() {
        let mainStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
        navigationManager = mainStoryboard.instantiateViewControllerWithIdentifier("TabBarController") as? TabBarController
    }

    func storeLocalSession(user: AnyObject) {
        
//        if (user.id.characters.count > 0) {
//            
//            self.localUser = user;
//            
//            let defaults = NSUserDefaults.standardUserDefaults()
//            
//            defaults.setObject(self.localUser?.getId(), forKey: "PKSignedUserId")
//            defaults.setObject(self.localSession?.getOauthToken(), forKey: "PKSignedUserToken")
//            
//            let userData = NSKeyedArchiver.archivedDataWithRootObject(self.localUser!)
//            defaults.setObject(userData, forKey: "PKSignedUser")
//            
//            let result : Bool = SSKeychain.setPassword(self.localSession?.password, forService: "com.outliers", account: self.localUser?.getId())
//            
//            if (!result) {
//                print("Error saving password to keychain")
//                
//                //setting the password in keychain failed, use encoder instead
//                defaults.setObject(self.localSession?.password, forKey: "PKSignedUserPassword")
//                
//            }
//            
//            defaults.synchronize()
//        }
    }
    
    func restoreLocalSession() -> Bool {
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let localUserId = defaults.objectForKey("PKSignedUserId")
//        
//        if(localUserId != nil) {
//            let token = defaults.objectForKey("PKSignedUserToken") as? String
//            
//            if let data = NSUserDefaults.standardUserDefaults().objectForKey("PKSignedUser") as? NSData {
//                let user = NSKeyedUnarchiver.unarchiveObjectWithData(data)
//                
//                if self.localUser = user as? User {
//                    
//                }
//                
//                self.cachedPoolOfUsers.setObject(localSession?.localUser!, forKey: (self.localUser?.getId())!)
//                
//                //            if let username = basicInfo["username"] as? String
//                
//                if let password = SSKeychain.passwordForService("com.outliers", account: self.localUser?.getId()) {
//                    self.localSession = LocalSession(password: password, oAuthToken: token!)
//                    
//                    return true
//                }
//            }
//        }
        
        return false
    }
    
    func clearLocalSession() {
//        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.removeObjectForKey("PKSignedUserId")
//        defaults.removeObjectForKey("PKSignedUser")
//        defaults.removeObjectForKey("PKSignedUserToken")
//        defaults.removeObjectForKey("PKSignedUserPassword")
//        defaults.removeObjectForKey("FailedRouteCreations")
//        
//        SSKeychain.deletePasswordForService("com.outliers", account: localSession?.localUser.id)
//        
//        localSession = nil
//        
//        defaults.synchronize()
        
    }
    
}
