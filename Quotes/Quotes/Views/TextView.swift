//
//  TextView.swift
//  Quotes
//
//  Created by James Ajhar on 8/30/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class TextView: UITextView {
    
    var placeholder: String?
    var placeholderColor: UIColor = UIColor.lightGrayColor()
    var placeholderLabel: UILabel
    var accessoryView: UIView?
    
    override internal var textContainerInset: UIEdgeInsets {
        get {
            return super.textContainerInset
        }
        set {
            super.textContainerInset = newValue
            placeholderLabel.frame = CGRectMake(newValue.left + 3.0, 8.0, bounds.size.width - (newValue.left - newValue.right), 0.0)
        }
    }
    
    private let UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.0
    private let UI_PLACEHOLDER_LABEL_TAG = 999
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        placeholderLabel = UILabel.init(frame: frame)
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        placeholderLabel = UILabel.init(coder: aDecoder)!
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        
        placeholderLabel = UILabel.init(frame: CGRectMake(3.5, 8.0, bounds.size.width - 7, 0.0))
        placeholderLabel.lineBreakMode = .ByWordWrapping
        placeholderLabel.numberOfLines = 0
        placeholderLabel.font = font
        placeholderLabel.backgroundColor = UIColor.clearColor()
        placeholderLabel.textColor = placeholderColor
        
        placeholderLabel.alpha = 0
        placeholderLabel.tag = UI_PLACEHOLDER_LABEL_TAG
        addSubview(placeholderLabel)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override internal var text: String! {
        didSet {
            textChanged(nil)
        }
    }
    
    override func drawRect(rect: CGRect) {
        if (!(placeholder ?? "").isEmpty) {
            placeholderLabel.textColor = placeholderColor
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
            sendSubviewToBack(placeholderLabel)
        }
        
        if ((text ?? "").isEmpty && !(placeholder ?? "").isEmpty)  {
            viewWithTag(UI_PLACEHOLDER_LABEL_TAG)?.alpha = 1
        }
        
        super.drawRect(rect)
    }
    
    func textChanged(notification: NSNotification?) {
        if (!(placeholder ?? "").isEmpty) {
            UIView.animateWithDuration(UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION, animations: { () -> Void in
                if ((self.text ?? "").isEmpty) {
                    self.viewWithTag(self.UI_PLACEHOLDER_LABEL_TAG)?.alpha = 1.0
                } else {
                    self.viewWithTag(self.UI_PLACEHOLDER_LABEL_TAG)?.alpha = 0.0
                }
            })
        } else {
            return
        }
    }

}
