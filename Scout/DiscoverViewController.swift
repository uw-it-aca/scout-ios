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

class DiscoverViewController: ApplicationController {
    
    override var URL: Foundation.URL {
        return Foundation.URL(string: "\(host)/\(campus)/")!
    }
    
    // discover visit controller
    override func presentVisitableForSession(_ session: Session, URL: Foundation.URL, action: Action = .Advance) {
        
        let visitable = VisitableViewController(url: URL)
        
        // discover home
        if URL.path == "/h/\(campus)" {
            
            let campusButton : UIBarButtonItem = UIBarButtonItem(title: (campus).capitalized, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ApplicationController.chooseCampus))
            //let settingsButton : UIBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ApplicationController.openSettings))
            
            //let buttonIcon = UIImage(named: "ic_settings")
            //settingsButton.image = buttonIcon
            
            visitable.navigationItem.rightBarButtonItem = campusButton
            //visitable.navigationItem.rightBarButtonItem = settingsButton
            
            visitable.navigationItem.setRightBarButtonItems([/*settingsButton,*/ campusButton], animated: true)
            
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
