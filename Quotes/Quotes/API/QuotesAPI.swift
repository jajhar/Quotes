//
//  QuotesApi.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import CoreData

class QuotesAPI: APICommunication {
    
    func getQuotes(withOffset dateOffset: String?, clearState: Bool, completion: ([Quote]) -> Void, failure: FailureBlock) {
        
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
                                    
//                                    if clearState {
//                                        QuotesDataManager.DeleteAllQuotes(inContext: CoreDataManager.managedObjectContext)
//                                    }
                                    
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
    
    func getQuotes(forUser user: User, withOffset dateOffset: String?, clearState: Bool, completion: ([Quote]) -> Void, failure: FailureBlock) {
        
        super.sendRequestWithURL(URLs.getQuotes(forUser: user.id!, withOffset: dateOffset),
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
                                    
//                                    if clearState {
//                                        QuotesDataManager.DeleteAllQuotes(inContext: CoreDataManager.managedObjectContext)
//                                    }
                                    
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

}
