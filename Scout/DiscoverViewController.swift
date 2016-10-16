//
//  DiscoverViewController.swift
//  Scout
//
//  Created by Charlon Palacay on 7/14/16.
//  Copyright © 2016 Charlon Palacay. All rights reserved.
//

import UIKit

class DiscoverViewController: ApplicationController {
    
    override var URL: NSURL {
        return NSURL(string: "\(host)/")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 270, y: 20, width: 70, height: 44)) // Offset by 20 pixels vertically to take the status bar into account
        
        // green navbar
        navigationBar.barTintColor = UIColor.greenColor()
        
        // transparent navbar
        //navigationBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
        //navigationBar.translucent = true
        //navigationBar.shadowImage = UIImage()
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        
        // Create left and right button for navigation item
        let rightButton = UIBarButtonItem(title: "Right", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        // Create a button for the navigation item
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        
        
    }
    
}
