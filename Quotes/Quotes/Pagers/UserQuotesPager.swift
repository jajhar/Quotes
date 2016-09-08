//
//  UserQuotesPager.swift
//  Quotes
//
//  Created by James Ajhar on 9/1/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation

enum UserQuotesFilter {
    case saidBy
    case heardBy
}

public class UserQuotesPager : Pager {
    
    private let api = QuotesAPI()
    
    private var quotes: [UserQuotesFilter: [Quote]] = [.saidBy: [], .heardBy: []]
    var endOfPagesDict: [UserQuotesFilter: Bool] = [.saidBy: false, .heardBy: false]
    private var nextDateOffsets: [UserQuotesFilter: NSDate?] = [.saidBy: nil, .heardBy: nil]
    private var nextAPIPages: [UserQuotesFilter: String] = [.saidBy: "", .heardBy: ""]
    var filter: UserQuotesFilter = .saidBy
    var user: User?
    
    override var elements: [AnyObject] {
        get {
            return quotes[filter]!
        }
    }
    
    override var isEndOfPages: Bool {
        get {
            return endOfPagesDict[filter]!
        }
    }
    
    override func makeGetRequestWithCompletion(completion: PagerCompletionBlock?) {
        super.makeGetRequestWithCompletion(completion)
        
        guard let user = user else {
            print("UserQuotesPager: Unable to fetch quotes for nil user")
            markEndOfpages()
            completion?([], nil)
            return
        }
        
        api.getQuotes(forUser: user, withFilter: filter, withOffset: nextAPIPages[filter], completion: { (newQuotes) in
            completion?(newQuotes, nil)
            
        }) { (response, error) in
            completion?([], error)
        }
        
    }
    
    override func fetchLocalData(elements: [AnyObject], completion: PagerCompletionBlock?) {
        guard let user = user else {
            completion?([], nil)
            return
        }
        
        var predicate: NSPredicate!
        
        if user != AppData.sharedInstance.localSession?.localUser {
            // not the logged in user
            predicate = NSPredicate(format: "saidBy = %@ and %@ in heardBy", user, AppData.sharedInstance.localSession!.localUser!)
        } else {
            switch filter {
            case .heardBy:
                predicate = NSPredicate(format: "%@ in heardBy", user)
            case .saidBy:
                predicate = NSPredicate(format: "saidBy = %@", user)
            }
        }
       
        if let date = nextDateOffsets[filter]! {
            let datePredicate = NSPredicate(format: "createdAt < %@", date)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, datePredicate])
        }
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        
        let blockFilter = self.filter
        
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
                                            
                                            self.quotes[blockFilter]!.appendContentsOf(newQuotes)
                                            
                                            // save next page offset
                                            if let quote = newQuotes.last {
                                                self.nextDateOffsets[blockFilter] = quote.createdAt
                                                self.nextAPIPages[blockFilter] = quote.rawCreateTimeString
                                            }
                                        }
                                        
                                        completion?(newQuotes, nil)
        }
    }
    
    override public func clearStateAndElements() {
        super.clearStateAndElements()
        quotes[filter]?.removeAll()
        nextDateOffsets[filter] = nil
        endOfPagesDict[filter] = false
    }
    
    override public func markEndOfpages() {
        super.markEndOfpages()
        endOfPagesDict[filter] = true
    }
}
