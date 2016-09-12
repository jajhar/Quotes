//
//  ColoredCompletionTextField.swift
//  Quotes
//
//  Created by James Ajhar on 9/11/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class ColoredCompletionTextField: TextFieldResignOnMiss {

    // MARK: Properties
    var unfilledColor: UIColor = .lightGrayColor()  // Default value
    var filledColor: UIColor = .redColor()          // Default value
    
    override func commonInit() {
        super.commonInit()
        
        self.addTarget(self, action: #selector(ColoredCompletionTextField.textFieldDidEndEditing), forControlEvents: .EditingDidEnd)

        layer.borderWidth = 1
        layer.borderColor = unfilledColor.CGColor
    }
    
    func textFieldDidEndEditing() {
        if text != nil && !text!.isEmpty {
            // set to filled color
            textColor = filledColor
            layer.borderColor = filledColor.CGColor
        } else {
            // set to unfilled color
            textColor = unfilledColor
            layer.borderColor = unfilledColor.CGColor
        }
    }
    
}
