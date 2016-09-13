//
//  QuotesApi.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import CoreData
import SwiftAddressBook

public let kNotificationQuoteCreated = "NotificationQuoteCreated"

class QuotesAPI: APICommunication {
    
    func getQuotes(withOffset dateOffset: String?, completion: ([Quote]) -> Void, failure: FailureBlock) {
        
        print("sending request: \(URLs.getQuotes(withOffset: dateOffset))")
        
        super.sendRequestWithURL(URLs.getQuotes(withOffset: dateOffset),
                                 requestType: RequestType.GET,
                                 parameters: nil,
                                 completion: { (json) -> Void in
                                    
                                    guard let responseDict = json as? JSONDictionary else {
                                        print("ERROR: API Response is not JSON Compatible")
                                        failure(nil, nil)
                                        return
                                    }
                                    
                                    guard let responseArray = responseDict["data"] as? [JSONDictionary] else {
                                        print("ERROR: API Response missing data key")
                                        failure(nil, nil)
                                        return
                                    }
                                    
                                    var quotes = [Quote]()
                                    for rawQuote in responseArray {
                                        if let quote = QuotesDataManager.CreateQuoteWithJSON(rawQuote, inManagedObjectContext: CoreDataManager.managedObjectContext) {
                                            quotes.append(quote)
                                        }
                                    }
                                    
                                    completion(quotes)
                                    
        }) { (response, error) -> Void in
            print("ERROR: %@", error)
            failure(response, error)
        }
    }
    
    func getQuotes(forUser user: User, withFilter filter: UserQuotesFilter, withOffset dateOffset: String?, completion: ([Quote]) -> Void, failure: FailureBlock) {
        
        var url: NSURL!
        
        if filter == .saidBy {
            url = URLs.getSaidByQuotes(forUser: user.id!, withOffset: dateOffset)
        } else {
            url = URLs.getHeardByQuotes(withOffset: dateOffset)
        }
        
        super.sendRequestWithURL(url,
                                 requestType: RequestType.GET,
                                 parameters: nil,
                                 completion: { (json) -> Void in
                                    
                                    guard let responseDict = json as? JSONDictionary else {
                                        failure(nil, nil)
                                        return
                                    }
                                    
                                    guard let responseArray = responseDict["data"] as? [JSONDictionary] else {
                                        failure(nil, nil)
                                        return
                                    }
                                    
                                    var quotes = [Quote]()
                                    for rawQuote in responseArray {
                                        if let quote = QuotesDataManager.CreateQuoteWithJSON(rawQuote, inManagedObjectContext: CoreDataManager.managedObjectContext) {
                                            quotes.append(quote)
                                        }
                                    }
                                    
                                    completion(quotes)
                                    
        }) { (response, error) -> Void in
            print("ERROR: %@", error)
            failure(response, error)
        }
    }
    
    func searchQuotes(keyword: String, withOffset dateOffset: String?, completion: ([Quote]) -> Void, failure: FailureBlock) {
        
        print("sending request: \(URLs.searchQuotes(keyword, withOffset: dateOffset))")
        
        super.sendRequestWithURL(URLs.searchQuotes(keyword, withOffset: dateOffset),
                                 requestType: RequestType.GET,
                                 parameters: nil,
                                 completion: { (json) -> Void in
                                    
                                    guard let responseDict = json as? JSONDictionary else {
                                        print("ERROR: API Response is not JSON Compatible")
                                        failure(nil, nil)
                                        return
                                    }
                                    
                                    guard let responseArray = responseDict["data"] as? [JSONDictionary] else {
                                        print("ERROR: API Response missing data key")
                                        failure(nil, nil)
                                        return
                                    }
                                    
                                    var quotes = [Quote]()
                                    for rawQuote in responseArray {
                                        if let quote = QuotesDataManager.CreateQuoteWithJSON(rawQuote, inManagedObjectContext: CoreDataManager.managedObjectContext) {
                                            quotes.append(quote)
                                        }
                                    }
                                    
                                    completion(quotes)
                                    
        }) { (response, error) -> Void in
            print("ERROR: %@", error)
            failure(response, error)
        }
    }

    
    func createQuote(text: String, saidBy: SwiftAddressBookPerson, heardBy: [SwiftAddressBookPerson], saidDate: NSDate, completion: (Quote) -> Void, failure: FailureBlock) {
        
        var username = saidBy.fullName().stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())
        if username == nil { username = "" }
        
        let saidByParams: [String: AnyObject] = [
            "phone": saidBy.phoneNumbersList(),
            "username": username!
        ]
        
        var heardByList = [[String: AnyObject]]()
        for contact in heardBy {
            var username = contact.fullName().stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())
            if username == nil { username = "" }

            let obj: [String: AnyObject] = [
                "phone": contact.phoneNumbersList(),
                "username": username!
            ]
            
            heardByList.append(obj)
        }
        
        let params: [String: AnyObject] = [
            "text": text,
            "saidBy": saidByParams,
            "heardBy": heardByList,
            "saidDate": saidDate.timeIntervalSince1970
        ]
        
        print("sending request: \(URLs.createQuote())")

        super.sendRequestWithURL(URLs.createQuote(),
                                 requestType: .POST
            , parameters: params,
              completion: { (json) -> Void in
                
                guard let json = json else {
                    print("Create Quote response json is nil")
                    failure(nil, nil)
                    return
                }
                
                guard let rawQuote = json["quote"] as? JSONDictionary else {
                    print("Create Quote missing quote key in JSON")
                    failure(nil, nil)
                    return
                }
                
                guard let quote = QuotesDataManager.CreateQuoteWithJSON(rawQuote, inManagedObjectContext: CoreDataManager.managedObjectContext) else {
                    print("Failed to create quote from response JSON")
                    failure(nil, nil)
                    return
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName(kNotificationQuoteCreated, object: quote)
                
                completion(quote)
                
        }) { (response, error) -> Void in
            print("ERROR: %@", error)
            failure(response, error)
        }
    }


}
