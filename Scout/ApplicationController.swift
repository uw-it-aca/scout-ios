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
import CoreLocation
//import CoreMotion

class ApplicationController: UINavigationController, CLLocationManagerDelegate {
    
    // initialize location manager
    let locationManager = CLLocationManager()
    
    // initial URL contstruction
    var URL: Foundation.URL {
        return Foundation.URL(string: "\(host)/\(campus)/\(location)")!
    }
            
    fileprivate let webViewProcessPool = WKProcessPool()
    
    fileprivate var application: UIApplication {
        return UIApplication.shared
    }
    
    fileprivate lazy var webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        
        // name of js script handler that this controller with be communicating with
        configuration.userContentController.add(self, name: "scoutBridge")
 
        configuration.processPool = self.webViewProcessPool
        return configuration
    }()
    
    fileprivate lazy var session: Session = {
        let session = Session(webViewConfiguration: self.webViewConfiguration)
        session.webView.allowsLinkPreview = false
        session.delegate = self
        return session
    }()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        // user location feature (async)
        getUserLocation()
        
        // ITERATION 1: WAIT FOR A LOCATION BEFORE CALLING THE VISITABLE
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("delay visitabled long enough for location to be set")
            self.presentVisitableForSession(self.session, URL: self.URL)
        }
        
        // notification handler for detecting app foreground state
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
    }
    
    // generic visit controller... can be overridden by each view controller
    func presentVisitableForSession(_ session: Session, URL: Foundation.URL, action: Action = .Advance) {
        
        let visitable = VisitableViewController(url: URL)
                
        // handle actions
        if action == .Advance {
            pushViewController(visitable, animated: true)
        } else if action == .Replace {
            popViewController(animated: true)
            setViewControllers([visitable], animated: false)
        }
        
        session.visit(visitable)
        
    }
    
   
    @objc func appMovedToForeground() {
        
        print("app moved to forground")

        // only set user location if services are enabled
        if CLLocationManager.locationServicesEnabled() {
            print("moved to forground w/ location")
            
            // update user location when coming back from background
            getUserLocation()
            
            // reload session
            session.reload()
            
        }
        else {
            
            // clear the user location
            location = ""
            user_lat = ""
            user_lng = ""
            
            // turbolinks visit with empty location and force reload
            presentVisitableForSession(self.session, URL: self.URL, action: .Replace)
        
        }
       
     
    }

    
    // show filter
    @objc func presentFilter() {
        // filter specific url so we know what params were set
        let filterURL = Foundation.URL(string: "\(host)/\(campus)/\(app_type)/filter/?\(location)&\(params)")!
        presentVisitableForSession(session, URL: filterURL)
    }
    
    // submit filter function when user clickes on the filter back button
    @objc func submitFilter(){
        
        // set a new visitable URL that includes params and location
        let visitURL = Foundation.URL(string: "\(host)/\(campus)/\(app_type)/?\(location)&\(params)")!
        
        // get the previous URL and params from the session URL (presentFilter function)
        let sessionURL = session.webView.url?.absoluteString
        // remove the filter/ string from the URL
        let previousURL = sessionURL?.replacingOccurrences(of: "filter/", with: "")

        // check to see if the new visit URL matches what the user previously visited
        if (visitURL.absoluteString == previousURL!) {
            // if URLs match... no need to reload, just pop back to beginning of stack
            popViewController(animated: true);
        } else {
            // if they are different, force a reload by using the Replace action
            session.reload()
            presentVisitableForSession(session, URL: visitURL, action: .Replace)
        }
        
    }
    
    @objc func clearFilter() {
        // evaluate js by submitting click event
        session.webView.evaluateJavaScript("document.getElementById('filter_clear').click()", completionHandler: nil)
    }
    
    // custom controller for campus selection
    @objc func chooseCampus() {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Campus", preferredStyle: .actionSheet)
        
        // 2
        let seattleAction = UIAlertAction(title: "Seattle", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if campus != "seattle" {
                campus = "seattle"
                food_params = ""
                study_params = ""
                tech_params = ""
                UserDefaults.standard.set(campus, forKey: "usercampus")
                self.session.reload()
                self.presentVisitableForSession(self.session, URL: self.URL, action: .Replace)
            }
        })
        let bothellAction = UIAlertAction(title: "Bothell", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if campus != "bothell" {
                campus = "bothell"
                food_params = ""
                study_params = ""
                tech_params = ""
                UserDefaults.standard.set(campus, forKey: "usercampus")
                self.session.reload()
                self.presentVisitableForSession(self.session, URL: self.URL, action: .Replace)
            }
        })
        let tacomaAction = UIAlertAction(title: "Tacoma", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if campus != "tacoma" {
                campus = "tacoma"
                food_params = ""
                study_params = ""
                tech_params = ""
                UserDefaults.standard.set(campus, forKey: "usercampus")
                self.session.reload()
                self.presentVisitableForSession(self.session, URL: self.URL, action: .Replace)
            }
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // 4
        optionMenu.addAction(seattleAction)
        optionMenu.addAction(bothellAction)
        optionMenu.addAction(tacomaAction)
        
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
        
    }

    
    func getUserLocation() {
        
        print("getUserLocation")
        
        self.locationManager.delegate = self
        
        // ask authorization only when in use by user
        self.locationManager.requestWhenInUseAuthorization()
        
        // set distanceFilter to only send location update if position changed from previous
        //self.locationManager.distanceFilter = 200 // 200 meters
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // start updating location
        self.locationManager.startUpdatingLocation()
  
    }
    
    // locationManager delegate functions
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue = manager.location?.coordinate else {
            return
        }
    
        if CLLocationManager.locationServicesEnabled() {
            
            
            if !((locValue.latitude.description == user_lat) && (locValue.longitude.description == user_lng)) {
                
                print("locationManager: save new location info to app delegate")
                location_enabled = true
                location_changed = true
                user_lat = locValue.latitude.description
                user_lng = locValue.longitude.description
                
            }
            else {
                print("same location")
                location_changed = false
            }
            
        } else {
            
            // no location services... clear location info
            location_enabled = false
            //location = ""
            user_lat = ""
            user_lng = ""
            
        }
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        NSLog("Error while updating location: %@", error.localizedDescription)
        self.locationManager.stopUpdatingLocation()
    }
    
    /*** INTERNET CONNECTION ERROR HANDLING SCOUT-710 & SCOUT-722 ***/
 
    lazy var errorView: ErrorView = {
        let view = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)!.first as! ErrorView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.retryButton.addTarget(self, action: #selector(retry(_:)), for: .touchUpInside)
        return view
    }()
    
    func presentError(_ error: Error) {
        errorView.error = error
        view.addSubview(errorView)
        installErrorViewConstraints()
    }
    
    func installErrorViewConstraints() {
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: [ "view": errorView ]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: [ "view": errorView ]))
    }
    
    @objc func retry(_ sender: AnyObject) {
        errorView.removeFromSuperview()
        // much cleaner way to reload session
        session.reload()
    }
 
}


extension ApplicationController: SessionDelegate {
    func session(_ session: Session, didProposeVisitToURL URL: Foundation.URL, withAction action: Action) {
        presentVisitableForSession(session, URL: URL, action: action)
    }
    
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        
        NSLog("ERROR: %@", error)
        guard let errorCode = ErrorCode(rawValue: error.code) else { return }
        
        switch errorCode {
        case .httpFailure:
            let statusCode = error.userInfo["statusCode"] as! Int
            switch statusCode {
            case 401:
                print("future work to handle authentication")
            case 404:
                presentError(.HTTPNotFoundError)
            default:
                presentError(Error(HTTPStatusCode: statusCode))
            }
        case .networkFailure:
            NSLog("no internet connection error happened")
            presentError(.NetworkError)
        }
    }
    
    func sessionDidStartRequest(_ session: Session) {
        application.isNetworkActivityIndicatorVisible = true
    }
    
    func sessionDidFinishRequest(_ session: Session) {
        application.isNetworkActivityIndicatorVisible = false
    }
    
    /**
    func sessionDidLoadWebView(_ session: Session) {
        
        print("sessionDidLoadWebView")
        //session.webView.evaluateJavaScript("Geolocation.getNativeLocation(\(user_lat), \(user_lng))", completionHandler: nil)
        
        // check if location enabled AND location has changed
        if ((location_enabled == true) && (location_changed == true)) {
            
            // pass location and store it as a persistent cookie on the webview server end
            // print("evaluateJavaScript: setting location as cookie")
            // set the location cookie on initial page load of the webview...
            // on the webview end, first thing is to check and make sure cookie has been set
            // before loading any content via ajax request
            
        } else {
            print("location is same... don't need to update store")
        }
    }
    **/

}

extension ApplicationController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        // set the params from the js bridge message
        if let message = message.body as? String {
            
            // display message for testing
            print(message)
            
            // if the message is "hello world" pass the user location -- this is what triggers webview rendering!
            if (message == "hello world") {
                
                print("hello world from js bridge")
                
                // if user_lat and user_lng
                //session.webView.evaluateJavaScript("Geolocation.getNativeLocation(\(user_lat), \(user_lng))", completionHandler: nil)
                
                // else send epmpty and let webview load defaults
                session.webView.evaluateJavaScript("Geolocation.getNativeLocation()", completionHandler: nil)
            }
            else {
                
                // treat all other messages as filters params and handle accordingly
                params = message
                
                if (app_type == "food") {
                    food_params = params
                } else if (app_type == "study") {
                    study_params = params
                } else if (app_type == "tech") {
                    tech_params = params
                }
                
            }
            
            
        }
        
    }
    
}
