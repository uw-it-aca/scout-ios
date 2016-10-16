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
        
        // right button for discover view
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem();
        
        // right button
        let rightBarButton = UIBarButtonItem(title: "Testing", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ApplicationController.dismiss))
        navItem.rightBarButtonItem = rightBarButton
        
        navBar.setItems([navItem], animated: false)
        
    }
    
}
