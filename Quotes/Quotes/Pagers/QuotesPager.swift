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
    override var elements: [AnyObject] {
        get {
            return quotes
        }
    }
    var nextDateOffset: NSDate?
   
    override func makeGetRequestWithCompletion(completion: PagerCompletionBlock?) {
        super.makeGetRequestWithCompletion(completion)

        api.getQuotes(withOffset: nextPage, completion: { (newQuotes) in
                        
            completion?(newQuotes, nil)
            
            }) { (response, error) in
                completion?([], error)
        }
    }

    
    override func fetchLocalData(elements: [AnyObject], completion: PagerCompletionBlock?) {
        
        guard let elements = elements as? [Quote] else {
            completion?([], nil)
            return
        }
        
        if elements.count == 0 {
            markEndOfpages()
            completion?([], nil)
            return
        }
        
        var predicateString = ""
        var ids = [String]()
        
        for i in 0..<elements.count {
            if let id = elements[i].id {
                ids.append(id)
                
                predicateString += "id = " + "%@"
                
                if i < elements.count - 1 {
                    predicateString += " or "
                }
            }
        }
        
        var predicate = NSPredicate(format: predicateString, argumentArray: ids)
        
        if let date = nextDateOffset {
            let datePredicate = NSPredicate(format: "createdAt < %@", date)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, datePredicate])
        }
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)

        QuotesDataManager.GetQuotes(inContext: CoreDataManager.managedObjectContext,
                                    fetchLimit: 20,
                                    withPredicate: predicate,
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








