//
//  TouchSensitiveWindow.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

let kQUNotificationWindowTapped = "QUNotificationWindowTapped"

class TouchSensitiveWindow: UIWindow {
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    * Dispatches events sent to the receiver by the UIApplication object to its views.
    */
    override func sendEvent(event: UIEvent) {
        
        if let touch = event.allTouches()?.first {
            
            if(touch.phase == UITouchPhase.Ended) {
                NSNotificationCenter.defaultCenter().postNotificationName(kQUNotificationWindowTapped, object: touch.view)
            }
        }
        
        super.sendEvent(event)
    }

}
