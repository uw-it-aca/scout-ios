//
//  DiscoverViewController.swift
//  Scout
//
//  Created by Charlon Palacay on 7/14/16.
//  Copyright © 2016 Charlon Palacay. All rights reserved.
//

import UIKit
import WebKit
import Turbolinks
import CoreLocation

class DiscoverViewController: ApplicationController {
    
    override var URL: Foundation.URL {

        if CLLocationManager.locationServicesEnabled() {
            return Foundation.URL(string: "\(host)/\(campus)/?\(location)")!
            
        } else {
            return Foundation.URL(string: "\(host)/\(campus)/")!
        }
        

    }
    
    // discover visit controller
    override func presentVisitableForSession(_ session: Session, URL: Foundation.URL, action: Action = .Advance) {
        
        print ("presentVisitableForSession DISCOVER")
        let visitable = VisitableViewController(url: URL)
        
        // discover home
        if URL.path == "/h/\(campus)" {
            
            // create top/right button to handle campus switching
            let campusButton : UIBarButtonItem = UIBarButtonItem(title: (campus).capitalized, style: .plain, target: self, action: #selector(ApplicationController.chooseCampus))
            visitable.navigationItem.rightBarButtonItem = campusButton
            visitable.navigationItem.setRightBarButtonItems([campusButton], animated: true)
            
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
}
