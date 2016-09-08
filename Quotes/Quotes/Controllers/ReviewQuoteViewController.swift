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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "REVIEW"
        
        saidTextField.autoCompleteDataSource = self
        heardTextField.autoCompleteDataSource = self
        saidTextField.autoCompleteDelegate = self
        heardTextField.autoCompleteDelegate = self
        saidTextField.reverseAutoCompleteSuggestionsBoldEffect = true
        heardTextField.reverseAutoCompleteSuggestionsBoldEffect = true
        
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
}

extension ReviewQuoteViewController: MLPAutoCompleteTextFieldDelegate, MLPAutoCompleteTextFieldDataSource {

    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!) -> [AnyObject]! {
        
        let lastString = string.componentsSeparatedByString(",").last!
        
        var strings = [String]()
        
        if let people = swiftAddressBook?.allPeople {
            for person in people {
                
                let fname = person.firstName != nil ? person.firstName! : ""
                let lname = person.lastName != nil ? person.lastName! : ""
                let fullName = fname + " " + lname
                
                let name = lastString.lowercaseString
                if fullName.lowercaseString.rangeOfString(name) != nil {
                    strings.append(fullName)
                }
            }
        }
        
        return strings
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, didSelectAutoCompleteString selectedString: String!, withAutoCompleteObject selectedObject: MLPAutoCompletionObject!, forRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
}