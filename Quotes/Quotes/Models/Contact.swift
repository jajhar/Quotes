//
//  Contact.swift
//  Quotes
//
//  Created by James Ajhar on 9/8/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import SwiftAddressBook
import MLPAutoCompleteTextField

class Contact: NSObject, MLPAutoCompletionObject {

    var person: SwiftAddressBookPerson?
    
    lazy var fullName: String = {
        guard let person = self.person else { return "" }
        
        let fname = person.firstName != nil ? person.firstName! : ""
        let lname = person.lastName != nil ? person.lastName! : ""
        let fullName = fname + " " + lname
        return fullName
    }()
    
    init(person: SwiftAddressBookPerson) {
        super.init()
        self.person = person
    }
    
    func autocompleteString() -> String! {
        return fullName
    }
}

extension SwiftAddressBookPerson {
    
    func fullName() -> String {
        var fullName: String = firstName != nil ? firstName! : ""
        if lastName != nil { fullName = fullName + " " + lastName! }
        return fullName
    }
    
    func phoneNumbersList() -> [String] {
        var phoneNumbersList = [String]()
        for number in phoneNumbers! {
            phoneNumbersList.append(number.value)
        }
        
        return phoneNumbersList
    }
}
