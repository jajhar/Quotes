//
//  CreateQuoteViewController.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class CreateQuoteViewController: ViewController {

    // MARK: Outlets
    @IBOutlet weak var textView: TextView!
    
    // MARK: Properties
    var keyboardToolBar: UIToolbar!
    var wordCounterItem: UIBarButtonItem!
    var createQuoteItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "QUOTES"
        
        textView.placeholder = "Say something..."
        textView.placeholderColor = .whiteColor()
        textView.delegate = self
        
        wordCounterItem = UIBarButtonItem(title: "200", style: .Plain, target: nil, action: nil)
        createQuoteItem = UIBarButtonItem(title: "QUOTE IT", style: .Plain, target: self, action: #selector(CreateQuoteViewController.createQuotePressed(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), 50)
        keyboardToolBar = UIToolbar(frame: frame)
        keyboardToolBar.items = [wordCounterItem, flexibleSpace, createQuoteItem]
        keyboardToolBar.sizeToFit()
        textView.inputAccessoryView = keyboardToolBar
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReviewQuoteSegue" {
            let rqController = segue.destinationViewController as! ReviewQuoteViewController
            let newQuote = Quote(text: textView.text)
            rqController.quote = newQuote
        }
    }
    
    // MARK: Interface Actions
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createQuotePressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("ReviewQuoteSegue", sender: self)
    }
}

extension CreateQuoteViewController: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text.characters.count + text.characters.count > 200 && text.characters.count > 0 {
            // character limit is 200
            return false
        }
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        wordCounterItem.title = String(format: "%lu", 200 - textView.text.characters.count)
    }
}
