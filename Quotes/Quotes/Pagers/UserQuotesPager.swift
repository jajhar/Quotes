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
    var nextDateOffset: NSDate?

    override func reloadWithCompletion(completion: PagerCompletionBlock?) {
        clearState = true
        super.reloadWithCompletion(completion)
    }
    
    override func makeGetRequestWithCompletion(completion: PagerCompletionBlock?) {
        super.makeGetRequestWithCompletion(completion)
        
        guard let user = user else {
            print("UserQuotesPager: Unable to fetch quotes for nil user")
            markEndOfpages()
            completion?([], nil)
            return
        }
        
        api.getQuotes(forUser: user, withOffset: nextPage, clearState: clearState, completion: { (newQuotes) in
            self.clearState = false
            
            completion?(newQuotes, nil)
            
        }) { (response, error) in
            completion?([], error)
        }
        
    }
    
    override func fetchLocalData(completion: PagerCompletionBlock?) {
        guard let userId = user?.id else {
            completion?([], nil)
            return
        }
        
        let datePredicate: NSPredicate? = self.nextDateOffset != nil ? NSPredicate(format: "ownerId = %@ and createdAt < %@", userId, self.nextDateOffset!) : nil
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        
        QuotesDataManager.GetQuotes(inContext: CoreDataManager.managedObjectContext,
                                    fetchLimit: 5,
                                    withPredicate: datePredicate,
                                    withSortDescriptors: [sortDescriptor]) { (newQuotes, error) in
                                        
                                        if let error = error {
                                            completion?([], error)
                                            return
                                        }
                                        
                                        if (newQuotes.count == 0) {
                                            // server has no more data
                                            self.markEndOfpages()
                                            
                                        } else {
                                            
                                            self.quotes.appendContentsOf(newQuotes)
                                            
                                            // save next page offset
                                            if let quote = newQuotes.last {
                                                self.nextDateOffset = quote.createdAt
                                                self.nextPage = quote.rawCreateTimeString
                                            }
                                        }
                                        
                                        completion?(newQuotes, nil)
        }
    }
    
    override func clearStateAndElements() {
        super.clearStateAndElements()
        quotes.removeAll()
        self.nextDateOffset = nil
    }
    
    override func markEndOfpages() {
        super.markEndOfpages()
        
    }
}
