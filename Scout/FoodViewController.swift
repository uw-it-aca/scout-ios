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

class FoodViewController: UINavigationController {
    
    var URL: NSURL {
        return NSURL(string: "\(host)/food/")!
    }
    
    private let webViewProcessPool = WKProcessPool()
    
    private var application: UIApplication {
        return UIApplication.sharedApplication()
    }
    
    private lazy var webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.processPool = self.webViewProcessPool
        return configuration
    }()
    
    private lazy var session: Session = {
        let session = Session(webViewConfiguration: self.webViewConfiguration)
        session.delegate = self
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentVisitableForSession(session, URL: URL)
    }
    
    //  visit controller for food
    
    func presentVisitableForSession(session: Session, URL: NSURL, action: Action = .Advance) {
        
        let visitable = VisitableViewController(URL: URL)
    
        if URL.path == "/h/seattle/food" {
            // YESSSSS! Adds a right button to the visitable controller
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FoodViewController.presentFoodFilter(_:)))
        }
        
        if action == .Advance {
            pushViewController(visitable, animated: true)
        } else if action == .Replace {
            popViewControllerAnimated(false)
            pushViewController(visitable, animated: false)
        }
        
        // set navbar tint (button link) color
        self.navigationBar.tintColor = hexStringToUIColor("#6564A9")
        
        session.visit(visitable)
    }
    
    // visit food filter

    func presentFoodFilter(sender: UIBarButtonItem){
        
        let visitable = VisitableViewController(URL: URL)
        visitable.visitableURL = NSURL(string: "http://curry.aca.uw.edu:8001/h/seattle/food/filter")
        
        visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FoodViewController.submit(_:)))
        
        pushViewController(visitable, animated: true)
        session.visit(visitable)
    }
    
    // TODO: submit form via JS Bridge
    
    func submit(sender: UIBarButtonItem){
        // pop the view controller
        popViewControllerAnimated(true)
        
        // TODO: reload foodcontroller with new filtered URL ????
        
    }
    
    // custom hex color function
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

extension FoodViewController: SessionDelegate {
    func session(session: Session, didProposeVisitToURL URL: NSURL, withAction action: Action) {
        
        // EXAMPPLE: intercept link clicks and do something custom
        
        if URL.path == "/h/seattle/food/filterxxx" {
            // define some custom function
            
        } else {
            presentVisitableForSession(session, URL: URL, action: action)
        }
        
    }
    
    func session(session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func sessionDidStartRequest(session: Session) {
        application.networkActivityIndicatorVisible = true
    }
    
    func sessionDidFinishRequest(session: Session) {
        application.networkActivityIndicatorVisible = false
    }
}
