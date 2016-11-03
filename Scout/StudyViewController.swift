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

class StudyViewController: ApplicationController {
    
    override var URL: NSURL {
        return NSURL(string: "\(host)/\(campus)/study/")!
    }
    
    
    
    // study view controller
    override func presentVisitableForSession(session: Session, URL: NSURL, action: Action = .Advance) {
        
        // set app_type to study
        app_type = "study"

        let visitable = VisitableViewController(URL: URL)
        
        // study home
        if URL.path == "/h/\(campus)/study" {
            
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ApplicationController.presentFilter))
            
        } else if URL.path == "/h/\(campus)/study/filter" {
            
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
    
}
