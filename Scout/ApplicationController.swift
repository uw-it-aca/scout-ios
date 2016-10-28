//
//  ApplicationViewController.swift
//  Scout
//
//  Created by Charlon Palacay on 8/11/16.
//  Copyright © 2016 Charlon Palacay. All rights reserved.
//

import UIKit
import WebKit
import Turbolinks

class ApplicationController: UINavigationController {
    
    var URL: NSURL {
        return NSURL(string: "\(host)/\(campus)/")!
    }
        
    private let webViewProcessPool = WKProcessPool()
    
    private var application: UIApplication {
        return UIApplication.sharedApplication()
    }
    
    private lazy var webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        
        // name of js script handler that this controller with be communicating with
        configuration.userContentController.addScriptMessageHandler(self, name: "scoutBridge")
        
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
    
    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        presentVisitableForSession(session, URL: URL, action: .Replace)
    }

    // generic visit controller
    func presentVisitableForSession(session: Session, URL: NSURL, action: Action = .Advance) {
        
        let visitable = VisitableViewController(URL: URL)
                
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
    
    // show app_type filter
    func presentFilter() {
        let URL = NSURL(string: "\(host)/\(campus)/\(app_type)/filter/")!
        presentVisitableForSession(session, URL: URL)
    }
    
    
    
    // execute javascript
    
    func submitFoodFilter(){
        // evaluate js by submitting click event
        session.webView.evaluateJavaScript("document.getElementById('\(app_type)_filter_submit').click()", completionHandler: nil)
    }
    
    func clearFoodFilter(){
        // evaluate js by submitting click event
        session.webView.evaluateJavaScript("document.getElementById('\(app_type)_filter_clear').click()", completionHandler: nil)
    }
    
    // custom controller for campus selection
    func chooseCampus() {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Campus", preferredStyle: .ActionSheet)
        
        // 2
        let seattleAction = UIAlertAction(title: "Seattle", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Seattle was selected")
            campus = "seattle"
            self.presentVisitableForSession(self.session, URL: self.URL, action: .Replace)
        })
        let bothellAction = UIAlertAction(title: "Bothell", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Bothell was selected")
            campus = "bothell"
            self.presentVisitableForSession(self.session, URL: self.URL, action: .Replace)
        })
        let tacomaAction = UIAlertAction(title: "Tacoma", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Tacoma was selected")
            campus = "tacoma"
            self.presentVisitableForSession(self.session, URL: self.URL, action: .Replace)
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
    
    func openSettings() {
        
        /***
         let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
         if let url = settingsUrl {
         UIApplication.sharedApplication().openURL(url)
         }
         ***/
        
    }
    
}

extension ApplicationController: SessionDelegate {
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

extension ApplicationController: WKScriptMessageHandler {
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        
        // TODO: not sure if this is a proper selector.
        if let message = message.body as? String {
            
            // update the URL to visit with the message (query param)
            // let URL = NSURL(string: "\(host)/\(campus)/food/\(message)")!
            
            // present the visitable URL with specific replace action (line 61 above)
            // presentVisitableForSession(session, URL: URL, action: .Replace)
            print(message)
            
        }
        
    }
    
}
