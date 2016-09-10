//
//  UITextViewExtensions.swift
//  Quotes
//
//  Created by James Ajhar on 9/8/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

extension UITextView {
    
    func removePadding() {
        textContainer.lineFragmentPadding = 0
        textContainerInset = UIEdgeInsetsZero
    }
}
