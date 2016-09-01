//
//  FeedPager.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation

class QuotesPager : Pager {
    
    private let api = QuotesAPI()

    private var quotes: [Quote] = [Quote]()
    private var clearState: Bool = true
    override var elements: [AnyObject] {
        get {
            return quotes
        }
    }
    
    override func reloadWithCompletion(completion: PagerCompletionBlock?) {
        clearState = true
        super.reloadWithCompletion(completion)
    }
    
    override func makeGetRequestWithCompletion(completion: PagerCompletionBlock) {
        super.makeGetRequestWithCompletion(completion)
        
        api.getQuotes(withOffset: nextPage, clearState: clearState, completion: { (newQuotes) in
            
            self.clearState = false
            
            if (newQuotes.count == 0) {
                // server has no more data
                self.markEndOfpages()
        
            } else {
    
                self.quotes.appendContentsOf(newQuotes)
    
                // save next page offset
                if let quote = newQuotes.last {
                    self.nextPage = quote.createdAt
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








