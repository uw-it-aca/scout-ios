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
        print("STUDY PARAMS... \(params)")
        if CLLocationManager.locationServicesEnabled() {
            return Foundation.URL(string: "\(host)/\(campus)/study/?\(location)&\(study_params)")!
            
        } else {
            return Foundation.URL(string: "\(host)/\(campus)/study/?\(study_params)")!
        }
    }
    
    // study view controller
    override func presentVisitableForSession(_ session: Session, URL: Foundation.URL, action: Action = .Advance) {
        
        let visitable = VisitableViewController(url: URL)
        
        // study home
        if URL.path == "/h/\(campus)/study" {
            
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.presentFilter))
            
        } else if URL.path == "/h/\(campus)/study/filter" {
            
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
        print("StudyViewDidAppear")
        // set app_type to study
        app_type = "study"
        params = study_params
        
    }
    
}
