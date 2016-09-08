//
//  NavigationController.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func makeTransparent() {
        // translucent nav bar
        navigationBar.translucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.backgroundColor = .clearColor()
    }
    
    func makeOpaque() {
        navigationBar.shadowImage = nil
        navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        navigationBar.backgroundColor = nil
    }
    
    func setTintColor(color: UIColor) {
        navigationBar.tintColor = color
    }
    
    func setTitleColor(color: UIColor) {
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName: color]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
