//
//  UserQuotesPager.swift
//  Quotes
//
//  Created by James Ajhar on 9/1/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation

class UserQuotesPager : Pager {
    
    private let api = QuotesAPI()
    
    private var quotes: [Quote] = [Quote]()
    private var clearState: Bool = true
    override var elements: [AnyObject] {
        get {
            return quotes
        }
    }
    var user: User?
    
    override func reloadWithCompletion(completion: PagerCompletionBlock?) {
        clearState = true
        super.reloadWithCompletion(completion)
    }
    
    override func makeGetRequestWithCompletion(completion: PagerCompletionBlock) {
        super.makeGetRequestWithCompletion(completion)
        
        guard let user = user else {
            print("UserQuotesPager: Unable to fetch quotes for nil user")
            completion([], nil)
            return
        }
        
        api.getQuotes(forUser: user, withOffset: nextPage, clearState: clearState, completion: { (newQuotes) in
            self.clearState = false
            
            if (newQuotes.count == 0) {
                // server has no more data
                self.markEndOfpages()
                
            } else {
                
                self.quotes.appendContentsOf(newQuotes)
                
                // save next page offset
                if let quote = newQuotes.last {
                    self.nextPage = quote.rawCreateTimeString
                }
                
            }
            
            completion(newQuotes, nil)
            
        }) { (response, error) in
            completion([], error)
        }
        
    }
    
    override func clearStateAndElements() {
        super.clearStateAndElements()
        quotes.removeAll()
    }
    
    override func markEndOfpages() {
        super.markEndOfpages()
        
    }
    
}
