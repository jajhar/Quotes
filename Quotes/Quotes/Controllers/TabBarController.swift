//
//  TabBarController.swift
//  Quotes
//
//  Created by James Ajhar on 8/26/16.
//  Copyright © 2016 Cameron Pierce. All rights reserved.
//

import UIKit
import PureLayout

class TabBarController: UITabBarController {
    
    //MARK: UIController
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.hidden = true
        
        // Setup custom tab bar
        let customTabBar = CustomTabBar(frame: CGRectZero)
        customTabBar.datasource = self
        customTabBar.delegate = self
        self.view.addSubview(customTabBar)
        customTabBar.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: view)
        customTabBar.autoPinEdge(.Left, toEdge: .Left, ofView: view)
        customTabBar.autoPinEdge(.Right, toEdge: .Right, ofView: view)
        customTabBar.autoSetDimension(.Height, toSize: 70.0)
        customTabBar.layoutIfNeeded()
        customTabBar.setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension TabBarController: ControllerPresentation {
    
    // MARK: ControllerPresentation
    
    func storyboardForControllerType(type: ControllerType) -> UIStoryboard {

        var storyboard: UIStoryboard!
        
        switch type {
        case .Login:
            storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        case .Quotes:
            storyboard = UIStoryboard(name: "QuotesStoryboard", bundle: nil)
        case .CreateQuote:
            storyboard = UIStoryboard(name: "CreateQuoteStoryboard", bundle: nil)
        case .Profile:
            storyboard = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
        }
        
        return storyboard
    }
    
    func presentControllerOfType(type: ControllerType) -> UIViewController {
        return presentControllerOfType(type, showTabBar: true, animated: true)
    }
    
    func presentControllerOfType(type: ControllerType, showTabBar: Bool, animated: Bool) -> UIViewController {
        
        let storyboard = storyboardForControllerType(type)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(type.rawValue)
        
        if let selectedController = self.selectedViewController as? NavigationController {
            // TODO: Check for duplicate controller before pushing a new one
            viewController.hidesBottomBarWhenPushed = !showTabBar
            selectedController.pushViewController(viewController, animated: animated)
        }
        
        return viewController
    }

}

extension TabBarController: CustomTabBarDelegate, CustomTabBarDataSource {
    
    // MARK: CustomTabBarDataSource
    
    func tabBarItemsInCustomTabBar(tabBarView: CustomTabBar) -> [UITabBarItem] {
        let quotesItem = UITabBarItem(title: nil, image: UIImage(named: "feedIcon"), tag: 0)
        let createQuoteItem = UITabBarItem(title: nil, image: UIImage(named: "quoteProcessIcon"), tag: 1)
        let profileItem = UITabBarItem(title: nil, image: UIImage(named: "ProfileIcon"), tag: 2)
        return [quotesItem, createQuoteItem, profileItem]
    }
    
    // MARK: CustomTabBarDelegate
    
    func didSelectViewController(tabBarView: CustomTabBar, atIndex index: Int) {
        self.selectedIndex = index
    }
}