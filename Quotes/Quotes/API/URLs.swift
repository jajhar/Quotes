//
//  URLs.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import Foundation

public class URLs {

    public static let baseURL = NSURL(string: "http://198.199.93.25:1337")
    
    public class func loginUser() -> NSURL {
        return NSURL(string: "login", relativeToURL: baseURL)!
    }
    
    public class func registerUser() -> NSURL {
        return NSURL(string: "user/profile", relativeToURL: baseURL)!
    }
    
    public class func getProfileForUserId(userId: String) -> NSURL {
        
        let url = String(format: "user/%@/profile", userId)
        
        return NSURL(string: url, relativeToURL: baseURL)!
    }
    
    public class func getQuotes(withOffset dateOffset: String?) -> NSURL {
        
        let url : String
        
        if(dateOffset != nil && dateOffset?.characters.count > 0) {
            url = String(format: "quotes?dateOffset=%@", dateOffset!)
        } else {
            url = String(format: "quotes")
        }
        
        return NSURL(string: url, relativeToURL: baseURL)!
    }
    
    public class func createQuote() -> NSURL {
        return NSURL(string: "quote", relativeToURL: baseURL)!
    }
    
    public class func searchQuotes(keyword: String, withOffset dateOffset: String?) -> NSURL {
        
        let url : String
        
        if(dateOffset != nil && dateOffset?.characters.count > 0) {
            url = String(format: "search/quotes/%@?dateOffset=%@", keyword, dateOffset!).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        } else {
            url = String(format: "search/quotes/%@", keyword).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        }
        
        return NSURL(string: url, relativeToURL: baseURL)!
    }
    
    public class func getSaidByQuotes(forUser userId: String, withOffset dateOffset: String?) -> NSURL {
        
        let url : String
        
        if(dateOffset != nil && dateOffset?.characters.count > 0) {
            url = String(format: "user/%@/quotes/said?dateOffset=%@", userId, dateOffset!)
        } else {
            url = String(format: "user/%@/quotes/said", userId)
        }
        
        return NSURL(string: url, relativeToURL: baseURL)!
    }

    public class func getHeardByQuotes(withOffset dateOffset: String?) -> NSURL {
        
        let url : String
        
        if(dateOffset != nil && dateOffset?.characters.count > 0) {
            url = String(format: "user/quotes/heard?dateOffset=%@", dateOffset!)
        } else {
            url = String(format: "user/quotes/heard")
        }
        
        return NSURL(string: url, relativeToURL: baseURL)!
    }
}