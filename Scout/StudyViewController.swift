//
//  StudyViewController.swift
//  Scout
//
//  Created by Charlon Palacay on 4/6/16.
//  Copyright © 2016 Charlon Palacay. All rights reserved.
//

import UIKit
import WebKit
import Turbolinks
import CoreLocation

class StudyViewController: ApplicationController {
    
    override var URL: Foundation.URL {
        
        if CLLocationManager.locationServicesEnabled() {
            return Foundation.URL(string: "\(host)/\(campus)/study/?\(location)")!
            
        } else {
            return Foundation.URL(string: "\(host)/\(campus)/study/")!
        }
    }
    
    // study view controller
    override func presentVisitableForSession(_ session: Session, URL: Foundation.URL, action: Action = .Advance) {
        
        let visitable = VisitableViewController(url: URL)
        
        // study home
        if URL.path == "/h/\(campus)/study" {
            
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.presentFilter))
            
        } else if URL.path == "/h/\(campus)/study/filter" {
            
            let backButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackButton"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.submitFilter))
            let backButtonText : UIBarButtonItem = UIBarButtonItem(title: "Study", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.submitFilter))
            
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
        
        // set app_type to study
        app_type = "study"
        params = study_params
        
    }
    
}
