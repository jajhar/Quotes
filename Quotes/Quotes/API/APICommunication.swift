//
//  APICommunication.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import Alamofire

enum RequestType {
    case GET
    case POST
    case PUT
    case DELETE
}

typealias JSONObject = AnyObject
typealias JSONDictionary = [String: JSONObject]
typealias CompletionBlock = (AnyObject?) -> Void
typealias ProgressBlock = (Float) -> Void
typealias FailureBlock = (NSURLResponse?, NSError?) -> Void

class APICommunication: NSObject {
    
    var requestQueue: NSOperationQueue = NSOperationQueue()
    
    
    func sendRequestWithURL(url: NSURL, requestType: RequestType, parameters: [String : AnyObject]?, completion: CompletionBlock, failure: FailureBlock) {
    
        var method : Alamofire.Method
        
        switch(requestType) {
            case RequestType.GET:
                method = Alamofire.Method.GET
                break
            case RequestType.POST:
                method = Alamofire.Method.POST
                break
            case RequestType.PUT:
                method = Alamofire.Method.PUT
                break
            case RequestType.DELETE:
                method = Alamofire.Method.DELETE
                break
        }
        
        let headers :[String: String]?
        
        
        if let token = AppData.sharedInstance.localSession?.oAuthToken {
            headers = [
                "token": token,
                "Content-Type": "application/json"
            ]
        } else {
            headers = nil
        }
        
        print("REQ: \(url)")
        print(headers);
        
        Alamofire.request(method, url, parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
            .response { request, response, data, error in
                
                if(error != nil) {
                    failure(response, error)
                }
                
            }.responseJSON { response in
                completion(response.result.value)
        }
    
    }

}
