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
import CoreLocation

class FoodViewController: ApplicationController {
    
    override var URL: Foundation.URL {
        if CLLocationManager.locationServicesEnabled() {
            return Foundation.URL(string: "\(host)/\(campus)/food/?\(location)&\(food_params)")!
            
        } else {
            return Foundation.URL(string: "\(host)/\(campus)/food/?\(food_params)")!
        }
        
    }
    
    // food view controller
    override func presentVisitableForSession(_ session: Session, URL: Foundation.URL, action: Action = .Advance) {
                
        let visitable = VisitableViewController(url: URL)
        
        // food home
        if URL.path == "/h/\(campus)/food" {
            
            // NOTE TO CRAIG: Functions called via #selectors CANNOT pass arguments. Every StackOverflow comment says how dumb and what is the point of this? LOL.
            // In any case... I made presentFilter pretty generic at the ApplicationController level and just accepting the global "app_type" variable. Each
            // context view controller (FoodViewController, StudyViewController, etc.) just overrides the value. Feel free to refactor!
            
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.presentFilter))
            
        } else if URL.path == "/h/\(campus)/food/filter" {
            
            // hide the default back button
            visitable.navigationItem.hidesBackButton = true
            
            // left button to clear filters
            visitable.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.clearFilter))

            // right button to update filters
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.submitFilter))
            
        }
        
        // handle actions
        if action == .Advance {
            pushViewController(visitable, animated: true)
        } else if action == .Replace {
            popViewController(animated: true)
            //pushViewController(visitable, animated: false)
            setViewControllers([visitable], animated: false)
        }
        
        session.visit(visitable)
    }
    

    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        // set app_type to food
        app_type = "food"
        params = food_params
        
    }
  
    
}
