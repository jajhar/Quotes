//
//  CustomTabBar.swift
//  CustomTabBar
//
//  Created by Adam Bardon on 07/03/16.
//  Copyright © 2016 Swift Joureny. All rights reserved.
//

import UIKit

protocol CustomTabBarDataSource {
    func tabBarItemsInCustomTabBar(tabBarView: CustomTabBar) -> [UITabBarItem]
}

protocol CustomTabBarDelegate {
    func didSelectViewController(tabBarView: CustomTabBar, atIndex index: Int)
}

class CustomTabBar: View {
    
    var datasource: CustomTabBarDataSource!
    var delegate: CustomTabBarDelegate!
    
    var tabBarItems: [UITabBarItem]!
    var customTabBarItems: [CustomTabBarItem]!
    var tabBarButtons: [UIButton]!
    var selectorView: View!
    var selectorConstraint: NSLayoutConstraint?
    
    override func commonInit() {
        super.commonInit()
        
        self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    }
    
    func setup() {
        // get tab bar items from default tab bar
        tabBarItems = datasource.tabBarItemsInCustomTabBar(self)
        
        customTabBarItems = []
        tabBarButtons = []
        
        let containers = createTabBarItemContainers()
        createTabBarItems(containers)
        
        // Selector View
        selectorView = View(frame: CGRectZero)
        selectorView.backgroundColor = .redColor()
        addSubview(selectorView)
        selectorView.autoPinEdgeToSuperviewEdge(.Bottom)
        selectorView.autoSetDimension(.Height, toSize: 3)
        selectorView.autoSetDimension(.Width, toSize: 70)
        layoutIfNeeded()
        
        moveSelectorView(toIndex: 0)
    }
    
    func createTabBarItems(containers: [CGRect]) {
        
        var index = 0
        for item in tabBarItems {
            
            let container = containers[index]
            
            let customTabBarItem = CustomTabBarItem(frame: container)
            customTabBarItem.setup(item)
            
            addSubview(customTabBarItem)
            customTabBarItems.append(customTabBarItem)
            
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: container.width, height: container.height))
            button.addTarget(self, action: #selector(CustomTabBar.barItemTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            customTabBarItem.addSubview(button)
            tabBarButtons.append(button)
            
            index += 1
        }
    }
    
    func createTabBarItemContainers() -> [CGRect] {
        
        var containerArray = [CGRect]()
        
        // create container for each tab bar item
        for index in 0..<tabBarItems.count {
            let tabBarContainer = createTabBarContainer(index)
            containerArray.append(tabBarContainer)
        }
        
        return containerArray
    }
    
    func createTabBarContainer(index: Int) -> CGRect {
        
        let tabBarContainerWidth = self.frame.width / CGFloat(tabBarItems.count)
        let tabBarContainerRect = CGRect(x: tabBarContainerWidth * CGFloat(index), y: 0, width: tabBarContainerWidth, height: self.frame.height)
        
        return tabBarContainerRect
    }
    
    func moveSelectorView(toIndex index: Int) {
        if let constraint = selectorConstraint {
            removeConstraint(constraint)
        }
        
        UIView.animateWithDuration(0.3) {
            self.selectorConstraint = self.selectorView.autoAlignAxis(.Vertical, toSameAxisOfView: self.customTabBarItems[index])
            self.layoutIfNeeded()
        }
    }
    
    func barItemTapped(sender : UIButton) {
        let index = tabBarButtons.indexOf(sender)!
        moveSelectorView(toIndex: index)
        delegate.didSelectViewController(self, atIndex: index)
    }
}
