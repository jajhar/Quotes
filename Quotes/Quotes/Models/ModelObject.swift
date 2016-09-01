//
//  ModelObject.swift
//  Quotes
//
//  Created by James Ajhar on 8/31/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import CoreData

class ModelObject: NSManagedObject {
        
    var json: JSONDictionary? {
        didSet {
            guard let json = json else { return }
            supplyJSONDictionary(json)
        }
    }
    
    func supplyJSONDictionary(json: JSONDictionary) {
        // NOP
    }
}
