//
//  TextFieldResignOnMiss.swift
//  Quotes
//
//  Created by James Ajhar on 9/5/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

@objc protocol TextFieldResignOnMissDelegate: UITextFieldDelegate {
    optional func textFieldDidChange(textField: UITextField)
}

class TextFieldResignOnMiss: UITextField {
    private weak var textFieldResignOnMissDelegate: TextFieldResignOnMissDelegate? = nil
    
    override internal weak var delegate: UITextFieldDelegate? {
        didSet {
            textFieldResignOnMissDelegate = delegate as? TextFieldResignOnMissDelegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextFieldResignOnMiss.windowTapNotificationReceived(_:)), name: kQUNotificationWindowTapped, object: nil)
        addTarget(self, action: #selector(TextFieldResignOnMissDelegate.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func windowTapNotificationReceived(notification: NSNotification) {
        if let view = notification.object as? UIView {
            if (self.isFirstResponder() && view != self) {
                self.resignFirstResponder()
            }
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        textFieldResignOnMissDelegate?.textFieldDidChange?(self)
    }
}
