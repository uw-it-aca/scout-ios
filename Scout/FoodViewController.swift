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
        return NSURL(string: "\(host)/\(campus)/food/")!
    }
    
    // food view controller
    override func presentVisitableForSession(session: Session, URL: NSURL, action: Action = .Advance) {
        
        let visitable = VisitableViewController(URL: URL)
        
        // food home
        if URL.path == "/h/\(campus)/food" {
            
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ApplicationController.presentFoodFilter))
            
        } else if URL.path == "/h/\(campus)/food/filter" {
            
            /***
             let submitButton : UIBarButtonItem = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ApplicationController.submitFoodFilter))
             let resetButton : UIBarButtonItem = UIBarButtonItem(title: "ClearForm", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ApplicationController.resetFoodList))
             
             visitable.navigationItem.rightBarButtonItem = submitButton
             visitable.navigationItem.rightBarButtonItem = resetButton
             
             visitable.navigationItem.setRightBarButtonItems([submitButton,resetButton], animated: true)
             ***/
            
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ApplicationController.clearFoodFilter))
            //visitable.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< BackSubmit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ApplicationController.submitFoodFilter))
            
        }
        
        // handle actions
        if action == .Advance {
            pushViewController(visitable, animated: true)
        } else if action == .Replace {
            popViewControllerAnimated(true)
            //pushViewController(visitable, animated: false)
            setViewControllers([visitable], animated: false)
        }
        
        session.visit(visitable)
    }
    
}
