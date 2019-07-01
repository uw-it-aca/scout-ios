//
//  TechViewController.swift
//  Scout
//
//  Created by Charlon Palacay on 7/14/16.
//  Copyright © 2016 Charlon Palacay. All rights reserved.
//

import UIKit
import WebKit
import Turbolinks
import CoreLocation

class TechViewController: ApplicationController {
    
    override var URL: Foundation.URL {
        if CLLocationManager.locationServicesEnabled() {
            return Foundation.URL(string: "\(host)/\(campus)/tech/?\(location)&\(tech_params)")!
            
        } else {
            return Foundation.URL(string: "\(host)/\(campus)/tech/?\(tech_params)")!
        }
    }
    
    // tech view controller
    override func presentVisitableForSession(_ session: Session, URL: Foundation.URL, action: Action = .Advance) {
                
        let visitable = VisitableViewController(url: URL)
        
        // tech home
        if URL.path == "/h/\(campus)/tech" {
            
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ApplicationController.presentFilter))
            
        } else if URL.path == "/h/\(campus)/tech/filter" {
            
            // hide the default back button
            visitable.navigationItem.hidesBackButton = true
            
            // left button to clear filters
            visitable.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ApplicationController.clearFilter))
            
            // right button to update filters
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ApplicationController.submitFilter))
            
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
        
        // set app_type to tech
        app_type = "tech"
        params = tech_params
        
    }
    
}
