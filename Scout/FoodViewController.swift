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
            
            // NOTE TO CRAIG: Functions called via #selectors CANNOT pass arguments. Every StackOverflow comment says how dumb and what is the point of this? LOL.
            // In any case... I made presentFilter pretty generic at the ApplicationController level and just accepting the global "app_type" variable. Each
            // context view controller (FoodViewController, StudyViewController, etc.) just overrides the value. Feel free to refactor!
            
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FoodViewController.presentFilter))
            
        } else if URL.path == "/h/\(campus)/food/filter" {
            
            let backButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackButton"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ApplicationController.submitFilter))
            let backButtonText : UIBarButtonItem = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ApplicationController.submitFilter))
             
            visitable.navigationItem.leftBarButtonItem = backButton
            visitable.navigationItem.leftBarButtonItem = backButtonText
             
            visitable.navigationItem.setLeftBarButtonItems([backButton,backButtonText], animated: true)

            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ApplicationController.clearFilter))
            
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
    
    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        
        // set app_type to food
        app_type = "food"
        
    }
    
    
}
