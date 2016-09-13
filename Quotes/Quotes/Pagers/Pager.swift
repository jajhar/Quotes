//
//  Pager.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation

public typealias PagerCompletionBlock = ([AnyObject], ErrorType?) -> Void

public class Pager : NSObject {
    
    private(set) var isEndOfPages : Bool
    private(set) var elements: [AnyObject]
    internal(set) var nextPage: String?

    public override init() {
        
        self.isEndOfPages = false
        self.elements = []
        self.nextPage = ""
        
        super.init()
    }
    
    public func reloadWithCompletion(completion: PagerCompletionBlock?) {
        nextPage = nil
        isEndOfPages = false
        makeGetRequestWithCompletion(completion, clearState: true)
    }
    
    public func getNextPageWithCompletion(completion: PagerCompletionBlock?) {
        makeGetRequestWithCompletion(completion, clearState: false)
    }
    
    internal func makeGetRequestWithCompletion(completion: PagerCompletionBlock?, clearState: Bool) {
        
        makeGetRequestWithCompletion { (elementArray, error) -> Void in
            
            if(clearState && error == nil) {
                self.clearStateAndElements()
            }
            
            self.fetchLocalData(elementArray, completion: completion)
        }
    }
    
    internal func makeGetRequestWithCompletion(completion: PagerCompletionBlock?) {
        // NOP (Handled by subclasses)
    }
    
    internal func fetchLocalData(elements: [AnyObject], completion: PagerCompletionBlock?) {
        // NOP (Handled by subclasses)
    }
    
    public func clearStateAndElements() {
        elements.removeAll()
        isEndOfPages = false
        nextPage = ""
    }
    
    public func markEndOfpages() {
        isEndOfPages = true
    }
        
}