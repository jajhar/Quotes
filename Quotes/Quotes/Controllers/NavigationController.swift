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
        
//        self.navigationBar.barTintColor = UIColor(red: 5.0/255.0, green: 71.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.navigationBar.tintColor = .redColor()
        self.navigationBar.translucent = true
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName: UIColor.redColor()]
        self.navigationBar.backgroundColor = .whiteColor()
        
        // translucent nav bar
//        self.navigationBar.translucent = true
//        self.navigationBar.shadowImage = UIImage()
//        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
