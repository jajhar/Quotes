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


}
