//
//  SearchPager.swift
//  Quotes
//
//  Created by James Ajhar on 9/7/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation

class SearchPager : Pager {
    
    private let api = QuotesAPI()
    
    private var quotes: [Quote] = [Quote]()
    var keyword: String?
    override var elements: [AnyObject] {
        get {
            return quotes
        }
    }
    var nextDateOffset: NSDate?
    
    override func makeGetRequestWithCompletion(completion: PagerCompletionBlock?) {
        super.makeGetRequestWithCompletion(completion)
        
        guard let keyword = keyword else {
            print("Warning: Search Pager is missing keyword value")
            completion?([], nil)
            return
        }
        
        api.searchQuotes(keyword, withOffset: nextPage, completion: { (newQuotes) in
                        
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