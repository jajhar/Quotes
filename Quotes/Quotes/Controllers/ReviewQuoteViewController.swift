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
import PureLayout
import MBProgressHUD

class ReviewQuoteViewController: ViewController {

    // MARK: Outlets
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var saidTextField: MLPAutoCompleteTextField!
    @IBOutlet weak var heardTextField: MLPAutoCompleteTextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    // MARK: Properties
    var quote: Quote? {
        didSet {
            syncToQuote()
        }
    }
    
    var saidContact: SwiftAddressBookPerson?
    var heardContacts: [SwiftAddressBookPerson] = [SwiftAddressBookPerson]()
    var saidDate: NSDate?
    var monthPickerView: UIPickerView = UIPickerView()
    var dayPickerView: UIPickerView = UIPickerView()
    var yearPickerView: UIPickerView = UIPickerView()
    var doneBarButtonItem: UIBarButtonItem!
    var currentHeardByNameString: String = ""
    var currentSaidByNameString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "REVIEW"
        
        doneBarButtonItem = UIBarButtonItem.init(title: "Done",
                                                 style: .Done,
                                                 target: self,
                                                 action: #selector(ReviewQuoteViewController.finishAndSavePressed(_:)))
        navigationItem.rightBarButtonItem = doneBarButtonItem
        doneBarButtonItem.enabled = false

        setupTextFields()
        setupPickerViews()
        setupDateToolBar()
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
        // NOP
    }
    
    func setupQuoteText() {
        guard let text = quote?.text else {
            return
        }
        quoteLabel.attributedText = NSAttributedString.AttributedStringWithQuotations(text,
                                                                                      attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
    }
    
    func setupTextFields() {
        saidTextField.autoCompleteDataSource = self
        heardTextField.autoCompleteDataSource = self
        saidTextField.autoCompleteDelegate = self
        heardTextField.autoCompleteDelegate = self
        saidTextField.reverseAutoCompleteSuggestionsBoldEffect = true
        heardTextField.reverseAutoCompleteSuggestionsBoldEffect = true
        
        saidTextField.delegate = self
        heardTextField.delegate = self
        
        saidTextField.addTarget(self, action: #selector(ReviewQuoteViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        heardTextField.addTarget(self, action: #selector(ReviewQuoteViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        saidTextField.layer.borderWidth = 1
        saidTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        heardTextField.layer.borderWidth = 1
        heardTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        let toolBar = UIToolbar(frame: CGRectZero)
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .Done,
                                         target: self,
                                         action: #selector(ReviewQuoteViewController.textFieldDonePressed(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        
        saidTextField.inputAccessoryView = toolBar
        heardTextField.inputAccessoryView = toolBar
    }
    
    func setupPickerViews() {
        monthPickerView.delegate = self
        monthPickerView.dataSource = self
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        
        // auto select last row (current year) on year picker
        yearPickerView.reloadAllComponents()
        yearPickerView.selectRow(yearPickerView.numberOfRowsInComponent(0)-1, inComponent: 0, animated: false)
    }
    
    func setupDateToolBar() {
        let dateToolBar = UIToolbar(frame: CGRectZero)
        let donePickingButton = UIBarButtonItem(title: "Done",
                                                style: .Done,
                                                target: self,
                                                action: #selector(ReviewQuoteViewController.pickerViewDonePressed(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        dateToolBar.items = [flexibleSpace, donePickingButton]
        dateToolBar.sizeToFit()
        
        monthTextField.inputView = monthPickerView
        dayTextField.inputView = dayPickerView
        yearTextField.inputView = yearPickerView
        
        monthTextField.inputAccessoryView = dateToolBar
        dayTextField.inputAccessoryView = dateToolBar
        yearTextField.inputAccessoryView = dateToolBar
    }
    
    func requestABAccess() {
        
        SwiftAddressBook.requestAccessWithCompletion({ (success, error) -> Void in
            if success {
                // NOP
            } else {
                print("Error Accessing Address Book: \(error)")
                let alert = UIAlertController(title: "Uh Oh!",
                    message: "We were unable to access your contacts list. Please allow us access under your device settings.",
                    preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
 
    func populateDayField(withDay day: Int) {
        dayTextField.text = day >= 10 ? "\(day)" : "0\(day)"
    }
    
    func populateMonthField(withMonth month: Int) {
        monthTextField.text = month >= 10 ? "\(month)" : "0\(month)"
    }
    
    func populateYearField(withYear year: Int) {
        yearTextField.text = "\(year)"
    }
    
    func repopulateHeardByField(withNewContact newContact: SwiftAddressBookPerson?) {
        
        var names = currentHeardByNameString.componentsSeparatedByString(", ")
        
        if newContact != nil {
            names.append(heardContacts.last!.fullName())
        }
        
        heardTextField.text = ""
        var objectsToRemove = [SwiftAddressBookPerson]()
        
        for i in 0..<heardContacts.count {
            
            let person = heardContacts[i]
            let fullName = person.fullName()
            
            var exists = false
            
            if names.contains(fullName) {
                exists = true
            }
            
            if !exists {
                objectsToRemove.append(person)
            } else {
                heardTextField.text = heardTextField.text! + fullName + ", "
            }
        }
        
        var contacts = [SwiftAddressBookPerson]()
        
        for person in heardContacts {
            if !objectsToRemove.contains(person) {
                contacts.append(person)
            }
        }
        
        heardContacts = contacts
        
        currentHeardByNameString = heardTextField.text!
    }
    
    func repopulateSaidByField() {
        guard let saidContact = saidContact else {
            saidTextField.text = ""
            return
        }
        saidTextField.text = ""
        let fullName = saidContact.fullName()
        
        if currentSaidByNameString == fullName {
            saidTextField.text = saidTextField.text! + fullName
            currentSaidByNameString = saidTextField.text!
        } else {
            saidTextField.text = ""
        }
    }
    
    func allFieldsFilled() -> Bool{
        
        if !saidTextField.text!.isEmpty &&
        !heardTextField.text!.isEmpty &&
        !monthTextField.text!.isEmpty &&
        !dayTextField.text!.isEmpty &&
        !yearTextField.text!.isEmpty {
            return true
        }
        
        return false
    }
    
    // MARK: Interface Actions
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldDonePressed(sender: AnyObject) {
        saidTextField.resignFirstResponder()
        heardTextField.resignFirstResponder()
    }
    
    func pickerViewDonePressed(sender: AnyObject) {
        
        if monthTextField.isFirstResponder() {
            populateMonthField(withMonth: monthPickerView.selectedRowInComponent(0) + 1)
            monthTextField.resignFirstResponder()
        } else if dayTextField.isFirstResponder() {
            populateDayField(withDay: dayPickerView.selectedRowInComponent(0) + 1)
            dayTextField.resignFirstResponder()
        } else if yearTextField.isFirstResponder() {
            populateYearField(withYear: yearPickerView.selectedRowInComponent(0) + 1)
            yearTextField.resignFirstResponder()
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        let date = dateFormatter.dateFromString("\(monthPickerView.selectedRowInComponent(0) + 1)/\(dayPickerView.selectedRowInComponent(0) + 1)/\(yearPickerView.selectedRowInComponent(0) + 1)")
        
        saidDate = date

        if saidDate == nil {
            // invalid date selection, need to reload day field, default it back to day 1
            saidDate = dateFormatter.dateFromString("\(monthPickerView.selectedRowInComponent(0) + 1)/1/\(yearPickerView.selectedRowInComponent(0) + 1)")
            populateDayField(withDay: 1)
        }

        // refresh all day components when changes are made
        dayPickerView.reloadAllComponents()
    }
    
    @IBAction func finishAndSavePressed(sender: UIBarButtonItem) {
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        
        QuotesAPI().createQuote(quote!.text!,
                                saidBy: saidContact!,
                                heardBy: heardContacts,
                                saidDate: saidDate!, completion: { (newQuote) in
                                    MBProgressHUD.hideHUDForView(self.view, animated: false)
                                    self.dismissViewControllerAnimated(true, completion: nil)

            }) { (response, error) in
                MBProgressHUD.hideHUDForView(self.view, animated: false)
                print("ERROR Creating Quote: \(error)")
                let alert = UIAlertController(title: "Uh Oh!", message: "Something went wrong. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
}

extension ReviewQuoteViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == saidTextField {
            requestABAccess()
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField == heardTextField {
            currentHeardByNameString = textField.text!
        } else if textField == saidTextField {
            currentSaidByNameString = textField.text!
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == saidTextField {
            
            repopulateSaidByField()
            
            if textField.text!.isEmpty {
                saidTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
                saidTextField.textColor = .lightGrayColor()
            } else {
                saidTextField.layer.borderColor = UIColor.redColor().CGColor
                saidTextField.textColor = .redColor()
            }
            
        } else if textField == heardTextField {
            
            repopulateHeardByField(withNewContact: nil)
            
            if textField.text!.isEmpty {
                heardTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
                heardTextField.textColor = .lightGrayColor()
            } else {
                heardTextField.layer.borderColor = UIColor.redColor().CGColor
                heardTextField.textColor = .redColor()
            }
        }
        
        if allFieldsFilled() {
            doneBarButtonItem.enabled = true
        }
    }
}

extension ReviewQuoteViewController: MLPAutoCompleteTextFieldDelegate, MLPAutoCompleteTextFieldDataSource {

    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!) -> [AnyObject]! {
        
        let lastString = string.componentsSeparatedByString(", ").last!
        
        var contacts = [Contact]()
        
        if let people = swiftAddressBook?.allPeople {
            for person in people {
                
                // Don't add people that don't have a phone number
                if person.phoneNumbers == nil ||
                   person.phoneNumbers?.count == 0 {
                    continue
                }
                
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
            
            repopulateHeardByField(withNewContact: person)
            
        } else if textField == saidTextField {
            
            guard let contact = selectedObject as? Contact else { return }
            guard let person = contact.person else { return }
            saidContact = person
            currentSaidByNameString = person.fullName()
        }
    }
}

extension ReviewQuoteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == monthPickerView {
            return 12
        }
        
        if pickerView == dayPickerView {
            
            if saidDate != nil {
                return saidDate!.numberOfDaysInCurrentMonth()
            } else {
                return 31 // default to 31 days, will change if necessary when month field changes
            }

        }
        
        if pickerView == yearPickerView {
            let currentDate = NSDate()
            return currentDate.getYear()
        }

        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
}
