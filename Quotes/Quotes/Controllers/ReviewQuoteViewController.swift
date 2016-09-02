//
//  ReviewQuoteViewController.swift
//  Quotes
//
//  Created by James Ajhar on 9/1/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class ReviewQuoteViewController: ViewController {

    // MARK: Outlets
    @IBOutlet weak var quoteLabel: UILabel!
    
    // MARK: Properties
    var quote: Quote? {
        didSet {
            syncToQuote()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "REVIEW"
        
        setupQuoteText()
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
    
    // MARK: Interface Actions
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
