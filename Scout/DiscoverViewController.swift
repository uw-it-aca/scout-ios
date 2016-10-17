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
    
    override var URL: NSURL {
        return NSURL(string: "\(host)/")!
    }
    
    // override generic visit controller w/ discover
    
    override func presentVisitableForSession(session: Session, URL: NSURL, action: Action = .Advance) {
        
        let visitable = VisitableViewController(URL: URL)
        
        // YESSSSS! Adds a right button to the visitable controller
        visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Campus", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DiscoverViewController.chooseCampus(_:)))
        
        if action == .Advance {
            pushViewController(visitable, animated: true)
        } else if action == .Replace {
            popViewControllerAnimated(false)
            pushViewController(visitable, animated: false)
        }

 
        session.visit(visitable)
 
    }
    
    // custom controller for campus selection
    func chooseCampus(sender: UIBarButtonItem) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Campus", preferredStyle: .ActionSheet)
        
        // 2
        let seattleAction = UIAlertAction(title: "Seattle", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Deleted")
        })
        let bothellAction = UIAlertAction(title: "Bothell", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Saved")
        })
        let tacomaAction = UIAlertAction(title: "Tacoma", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Saved")
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(seattleAction)
        optionMenu.addAction(bothellAction)
        optionMenu.addAction(tacomaAction)
        
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
        
    }
        
}
