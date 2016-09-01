//
//  UIViewExtensions.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit
import PureLayout

extension UIView {
    
    func constrainToSuperview() {
        autoPinEdgesToSuperviewMargins()
    }
    
    func makeCircular() {
        clipsToBounds = true
        layer.cornerRadius = CGRectGetWidth(frame) / 2.0
    }
    
    public class func loadFromNib(nibNameOrNil: String? = nil) -> Self {
        return loadFromNib(nibNameOrNil, type: self)
    }
    
    public class func loadFromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        let v: T? = loadFromNib(nibNameOrNil, type: T.self)
        return v!
    }
    
    public class func loadFromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        let nibViews = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
    
    public class var nibName: String {
        let name = "\(self)".componentsSeparatedByString(".").first ?? ""
        return name
    }
    
    public class var nib: UINib? {
        if let _ = NSBundle.mainBundle().pathForResource(nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
}