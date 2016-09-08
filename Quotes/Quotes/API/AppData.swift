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

    func storeLocalSession(token: String, user: User) {
        localSession = LocalSession(oAuthToken: token, localUser: user)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(token, forKey: "QUSignedUserToken")
        defaults.setObject(user.id, forKey: "QUSignedUserId")
        defaults.synchronize()
    }
    
    func restoreLocalSession() -> Bool {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        guard let localUserId = defaults.objectForKey("QUSignedUserId") as? String else {
            print("Unable to restore user session: User id is nil")
            return false
        }
        
        guard let token = defaults.objectForKey("QUSignedUserToken") as? String else {
            print("Unable to restore user session: Token is nil")
            return false
        }
        
        guard let user = UserDataManager.CreateUserWithJSON(["id": localUserId], inManagedObjectContext: CoreDataManager.managedObjectContext) else {
            print("Unable to restore user session: No user data found in local database")
            return false
        }
        
        localSession = LocalSession(oAuthToken: token, localUser: user)
        return true
    }
    
    func clearLocalSession() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("QUSignedUserId")
        defaults.removeObjectForKey("QUSignedUserToken")
        
        localSession = nil
        
        defaults.synchronize()
        
    }
    
    func logOut() {
        clearLocalSession()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let loginNavController = loginStoryboard.instantiateViewControllerWithIdentifier("LoginNavigationController") as! NavigationController
        loginNavController.makeTransparent()
        loginNavController.setTintColor(.whiteColor())
        
        appDelegate.window?.rootViewController = loginNavController
//        if let navController = appDelegate.window?.rootViewController as? UINavigationController {
//            navController.popToRootViewControllerAnimated(true)
//        }
    }
    
}
