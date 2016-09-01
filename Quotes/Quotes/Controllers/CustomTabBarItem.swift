//
//  CustomTabBarItem.swift
//  CustomTabBar
//
//  Created by Adam Bardon on 07/03/16.
//  Copyright © 2016 Swift Joureny. All rights reserved.
//

import UIKit
import PureLayout

class CustomTabBarItem: View {
    
    var iconView: UIImageView!
    
    override func commonInit() {
        super.commonInit()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    func setup(item: UITabBarItem) {
        
        guard let image = item.image else {
            print("No image found for tab bar item")
            return
        }
        
        // create imageView centered within a container
        iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        iconView.image = image
        iconView.sizeToFit()
        self.addSubview(iconView)
        iconView.autoCenterInSuperview()
        layoutIfNeeded()

    }
    
}
