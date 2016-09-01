//
//  StringExtensions.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    class func AttributedStringWithQuotations(string: String) -> NSAttributedString {
        
        let leftQuoteAttachment = NSTextAttachment()
        leftQuoteAttachment.image = UIImage(named:"leftQuotions")
        let rightQuoteAttachment = NSTextAttachment()
        rightQuoteAttachment.image = UIImage(named:"rightQuotations")
        
        let leftAttachmentString = NSAttributedString(attachment: leftQuoteAttachment)
        let rightAttachmentString = NSAttributedString(attachment: rightQuoteAttachment)
        
        let quoteString = NSMutableAttributedString(attributedString: leftAttachmentString)
        let quote = NSAttributedString(string: " " + string + " ")
        quoteString.appendAttributedString(quote)
        quoteString.appendAttributedString(rightAttachmentString)
        
        return quoteString
    }
}