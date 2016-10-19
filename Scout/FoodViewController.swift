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
        return NSURL(string: "\(host)/\(campus)/food/")!
    }
    
    private let webViewProcessPool = WKProcessPool()
    
    private var application: UIApplication {
        return UIApplication.sharedApplication()
    }
    
    private lazy var webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addScriptMessageHandler(self, name: "foodJsBridge")
        configuration.processPool = self.webViewProcessPool
        configuration.applicationNameForUserAgent = "Scout"
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
        
        // handle location state
        if URL.path == "/h/\(campus)/food" {
            // YESSSSS! Adds a right button to the visitable controller
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FoodViewController.presentFoodFilter))
        } else if URL.path == "/h/\(campus)/food/filter" {
            visitable.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FoodViewController.submit))
        }
        
        // handle actions
        if action == .Advance {
            pushViewController(visitable, animated: true)
        } else if action == .Replace {
            popViewControllerAnimated(false)
            pushViewController(visitable, animated: false)
        }
        
        session.visit(visitable)
    }
    
    // visit food filter

    func presentFoodFilter(){
        
        // go to food filter URL
        let URL = NSURL(string: "\(host)/\(campus)/food/filter/")!
        presentVisitableForSession(session, URL: URL)
    }
    
    // TODO: submit form via JS Bridge
    
    func submit(){
        
        // pop the view controller
        // popViewControllerAnimated(true)
        // TODO: reload foodcontroller with new filtered URL ????
        
        session.webView.evaluateJavaScript("document.getElementById('food_filter_submit').click()", completionHandler: nil)
        
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

extension FoodViewController: WKScriptMessageHandler {
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        
        // EXAMPPLE: handling of message from ios.js hybrid app
        if let message = message.body as? String {
            let alertController = UIAlertController(title: "From ios.js file", message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
}
