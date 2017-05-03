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
            return Foundation.URL(string: "\(host)/\(campus)/tech/?\(location)")!
            
        } else {
            return Foundation.URL(string: "\(host)/\(campus)/tech/")!
        }
    }
    
    // tech view controller
    override func presentVisitableForSession(_ session: Session, URL: Foundation.URL, action: Action = .Advance) {
                
        let visitable = VisitableViewController(url: URL)
        
        // tech home
        if URL.path == "/h/\(campus)/tech" {
            
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.presentFilter))
            
        } else if URL.path == "/h/\(campus)/tech/filter" {
            
            let backButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackButton"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.submitFilter))
            let backButtonText : UIBarButtonItem = UIBarButtonItem(title: "Tech", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.submitFilter))
            
            // fix spacing between back arrow and text
            backButton.imageInsets = UIEdgeInsetsMake(0, -7.0, 0, -30.0)
            
            visitable.navigationItem.leftBarButtonItem = backButton
            visitable.navigationItem.leftBarButtonItem = backButtonText
            
            visitable.navigationItem.setLeftBarButtonItems([backButton,backButtonText], animated: true)
            
            
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.clearFilter))
            
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
        
    }
    
}
