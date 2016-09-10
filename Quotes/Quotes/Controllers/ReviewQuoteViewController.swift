//
//  ReviewQuoteViewController.swift
//  Quotes
//
//  Created by James Ajhar on 9/1/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import SwiftAddressBook
import MLPAutoCompleteTextField

class ReviewQuoteViewController: ViewController {

    // MARK: Outlets
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var saidTextField: MLPAutoCompleteTextField!
    @IBOutlet weak var heardTextField: MLPAutoCompleteTextField!
    
    // MARK: Properties
    var quote: Quote? {
        didSet {
            syncToQuote()
        }
    }
    
    var saidContact: SwiftAddressBookPerson?
    var heardContacts: [SwiftAddressBookPerson] = [SwiftAddressBookPerson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "REVIEW"
        
        saidTextField.autoCompleteDataSource = self
        heardTextField.autoCompleteDataSource = self
        saidTextField.autoCompleteDelegate = self
        heardTextField.autoCompleteDelegate = self
        saidTextField.reverseAutoCompleteSuggestionsBoldEffect = true
        heardTextField.reverseAutoCompleteSuggestionsBoldEffect = true
        
        saidTextField.delegate = self
        heardTextField.delegate = self
        
        saidTextField.layer.borderWidth = 1
        saidTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        heardTextField.layer.borderWidth = 1
        heardTextField.layer.borderColor = UIColor.lightGrayColor().CGColor

        
//        let datePickerView:UIDatePicker = UIDatePicker()
//
//        datePickerView.datePickerMode = UIDatePickerMode.Date
//        
//        sender.inputView = datePickerView
//        
//        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)

        setupQuoteText()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? NavigationController {
            navigationController.setTintColor(.redColor())
            navigationController.setTitleColor(.redColor())
            navigationController.makeTransparent()
        }
    }
    
    func syncToQuote() {
        
    }
    
    func setupQuoteText() {
        guard let text = quote?.text else {
            return
        }
        quoteLabel.attributedText = NSAttributedString.AttributedStringWithQuotations(text,
                                                                                      attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
    }
    
    func requestABAccess() {
        
        SwiftAddressBook.requestAccessWithCompletion({ (success, error) -> Void in
            if success {
                //do something with swiftAddressBook
                
            }
            else {
                //no success. Optionally evaluate error
            }
        })
    }
    
    func repopulateHeardByField() {
        heardTextField.text = ""
        for person in heardContacts {
            let fname = person.firstName != nil ? person.firstName! : ""
            let lname = person.lastName != nil ? person.lastName! : ""
            let fullName = fname + " " + lname
            heardTextField.text = heardTextField.text! + fullName + ", "
        }
    }
    
    func repopulateSaidByField() {
        guard let saidContact = saidContact else {
            saidTextField.text = ""
            return
        }
        saidTextField.text = ""
        let fname = saidContact.firstName != nil ? saidContact.firstName! : ""
        let lname = saidContact.lastName != nil ? saidContact.lastName! : ""
        let fullName = fname + " " + lname
        saidTextField.text = saidTextField.text! + fullName

    }
    
    // MARK: Interface Actions
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}

extension ReviewQuoteViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == saidTextField {
            requestABAccess()
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == saidTextField {
            
            repopulateSaidByField()
            
            if textField.text!.isEmpty {
                saidTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
            } else {
                saidTextField.layer.borderColor = UIColor.redColor().CGColor
            }
            
            
        } else if textField == heardTextField {
            
            repopulateHeardByField()
            
            if textField.text!.isEmpty {
                heardTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
            } else {
                heardTextField.layer.borderColor = UIColor.redColor().CGColor
            }
        }
    }
}

extension ReviewQuoteViewController: MLPAutoCompleteTextFieldDelegate, MLPAutoCompleteTextFieldDataSource {

    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!) -> [AnyObject]! {
        
        let lastString = string.componentsSeparatedByString(", ").last!
        
        var contacts = [Contact]()
        
        if let people = swiftAddressBook?.allPeople {
            for person in people {
                
                let contact = Contact(person: person)
                let name = lastString.lowercaseString
                
                if contact.fullName.lowercaseString.rangeOfString(name) != nil {
                    contacts.append(contact)
                }
            }
        }
        
        return contacts
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, didSelectAutoCompleteString selectedString: String!, withAutoCompleteObject selectedObject: MLPAutoCompletionObject!, forRowAtIndexPath indexPath: NSIndexPath!) {
        
        if textField == heardTextField {
            
            guard let contact = selectedObject as? Contact else { return }
            guard let person = contact.person else { return }
            
            if !heardContacts.contains(person) {
                heardContacts.append(person)
            }
            
            repopulateHeardByField()
        } else if textField == saidTextField {
            
            guard let contact = selectedObject as? Contact else { return }
            guard let person = contact.person else { return }
            saidContact = person
        }
    }
}
