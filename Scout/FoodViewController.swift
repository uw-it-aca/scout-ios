//
//  FoodViewController.swift
//  Scout
//
//  Created by Charlon Palacay on 4/6/16.
//  Copyright © 2016 Charlon Palacay. All rights reserved.
//

import UIKit
import WebKit
import Turbolinks

class FoodViewController: ApplicationController {
    
    override var URL: NSURL {
        return NSURL(string: "\(host)/food/")!
    }
    
    // override generic visit controller w/ discover
    
    override func presentVisitableForSession(session: Session, URL: NSURL, action: Action = .Advance) {
        
        let visitable = VisitableViewController(URL: URL)
        
        // YESSSSS! Adds a right button to the visitable controller
        visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        if action == .Advance {
            pushViewController(visitable, animated: true)
        } else if action == .Replace {
            popViewControllerAnimated(false)
            pushViewController(visitable, animated: false)
        }
        
        session.visit(visitable)
    }
    
}
