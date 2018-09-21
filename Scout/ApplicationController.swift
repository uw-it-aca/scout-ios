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
import CoreMotion

class ApplicationController: UINavigationController,  CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
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
        
        // user location feature
        setUserLocation()
        if (!CLLocationManager.locationServicesEnabled()) {
            presentVisitableForSession(session, URL: URL)
        }
        presentVisitableForSession(session, URL: URL)
    }

    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        let sessionURL = session.webView.url?.absoluteString
        
        // location specific feature
        /**
        if (sessionURL == nil) {
            print ("looking for location")
        } else {
            // check to see if the campus or location has changed from what was previously set in session
            if (sessionURL!.lowercased().range(of: campus) == nil) {
                presentVisitableForSession(session, URL: URL, action: .Replace)
            } else if ((CLLocationManager.locationServicesEnabled()) && (sessionURL!.lowercased().range(of: location) == nil)) {
                presentVisitableForSession(session, URL: URL, action: .Replace)
            }
        }
         **/
        
        if (sessionURL != nil) {
            if (sessionURL!.lowercased().range(of: campus) == nil) {
                presentVisitableForSession(session, URL: URL, action: .Replace)
            }
        }
        
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
    
    // show filter
    @objc func presentFilter() {
        // location specific URL
        // let URL = Foundation.URL(string: "\(host)/\(campus)/\(app_type)/filter/?\(location)&\(params)")!

        
        presentVisitableForSession(session, URL: URL)
    }
    
    // submit filter function when user clickes on the filter back button
    @objc func submitFilter(){
        // set a new visitable URL that includes params and location
        // let visitURL = Foundation.URL(string: "\(host)/\(campus)/\(app_type)/?\(location)&\(params)")!
        
        // set a new visitable URL with only params
        let visitURL = Foundation.URL(string: "\(host)/\(campus)/\(app_type)/?\(params)")!

        
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

    
    func openSettings() {
        // no longer supported in ios10.. sucks!
        // UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=Scout")!)
    }
    
    
    func setUserLocation() {
        
        // ask authorization only when in use by user
        self.locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            //print("location enabled... send user location")
            self.locationManager.delegate = self
            // set distanceFilter to only send location update if position changed
            self.locationManager.distanceFilter = 1000 // 1000 meters.. or 1096 yards (half football field * 10)
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.requestLocation()
            
        } else {
            print("location disabled.. will use campus default locations instead")
        }
        
        
        
    }
    
    // locationManager delegate functions
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue = manager.location?.coordinate else {
            return
        }
        // send the lat/lng to the geolocation function on web
        // session.webView.evaluateJavaScript("$.event.trigger(Geolocation.location_updating)", completionHandler: nil)
        // session.webView.evaluateJavaScript("Geolocation.set_is_using_location(true)", completionHandler: nil)
        // session.webView.evaluateJavaScript("Geolocation.send_client_location(\(locValue.latitude),\(locValue.longitude))", completionHandler: nil)
        
        // update user location variable and reload the URL
        location = "h_lat=\(locValue.latitude)&h_lng=\(locValue.longitude)"
        //print("user location.. \(location)")
        presentVisitableForSession(self.session, URL: self.URL, action: .Replace)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        //print("Error while updating location: " + error.localizedDescription)
        //session.webView.evaluateJavaScript("Geolocation.set_is_using_location(false)", completionHandler: nil)
        print("error")
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
        print("have user reload the app if they become disconnected")
        
        // force reload of the current URL
        //presentVisitableForSession(session, URL: URL, action: .Replace)
        
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
            print("no internet connection error happened")
            presentError(.NetworkError)
        }
    }
    
    func sessionDidStartRequest(_ session: Session) {
        application.isNetworkActivityIndicatorVisible = true
    }
    
    func sessionDidFinishRequest(_ session: Session) {
        application.isNetworkActivityIndicatorVisible = false
    }
    
}

extension ApplicationController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // set the params from the js bridge message
        if let message = message.body as? String {
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
