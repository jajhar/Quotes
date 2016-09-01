//
//  Pager.swift
//  Quotes
//
//  Created by Cameron Pierce on 11/25/15.
//  Copyright © 2015 Cameron Pierce. All rights reserved.
//

import Foundation

public typealias PagerCompletionBlock = ([AnyObject], ErrorType?) -> Void

public class Pager : NSObject {
    
    public var isEndOfPages : Bool
    private(set) var elements: [AnyObject]
    public var nextPage: String?
    
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
            
            completion?(elementArray, error)
        }
    }
    
    internal func makeGetRequestWithCompletion(completion: PagerCompletionBlock) {
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
    
    public func isEndOfpages() -> Bool {
        return isEndOfPages
    }
        
}