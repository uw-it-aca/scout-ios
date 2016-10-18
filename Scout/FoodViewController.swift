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
        
        if visitable.visitableURL.absoluteString == "http://curry.aca.uw.edu:8001/h/seattle/food/" {
            // YESSSSS! Adds a right button to the visitable controller
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FoodViewController.presentFoodFilter(_:)))
        }
        
        if action == .Advance {
            pushViewController(visitable, animated: true)
        } else if action == .Replace {
            popViewControllerAnimated(false)
            pushViewController(visitable, animated: false)
        }
        
        session.visit(visitable)
    }
    
    // custom food filter controller
    func presentFoodFilter(sender: UIBarButtonItem){
        
        let authenticationController = FoodFilterViewController()
        //authenticationController.webViewConfiguration = webViewConfiguration
        authenticationController.URL = NSURL(string: "http://curry.aca.uw.edu:8001/h/seattle/food/filter")
        authenticationController.title = "Filter"
        
        // left button
        authenticationController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action:
            #selector(FoodViewController.dismiss(_:)))
        
        // right button
        authenticationController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FoodViewController.submit(_:)))
        
        // create navigation controller
        let authNavigationController = UINavigationController(rootViewController: authenticationController)
        
        // show the food filter navigation controller
        presentViewController(authNavigationController, animated: true, completion: nil)
        
    }
    
    func dismiss(sender: UIBarButtonItem){
        // close the view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func submit(sender: UIBarButtonItem){
        // close the view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
