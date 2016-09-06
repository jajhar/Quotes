//
//  ControllerPresentation.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit


protocol ControllerPresentation {
    func controllerForType(type: ControllerType) -> UIViewController
    func storyboardForControllerType(type: ControllerType) -> UIStoryboard
}

enum ControllerType : String {
    case Login = "LoginViewController"
    case Quotes = "QuotesViewController"
    case CreateQuote = "CreateQuoteViewController"
    case Profile = "ProfileViewController"
    case ReviewQuote = "ReviewQuoteViewController"
}
