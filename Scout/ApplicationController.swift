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

class ApplicationController: UINavigationController,  CLLocationManagerDelegate {
    
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
        
        // user location feature (async)
        setUserLocation()
    
        // initial turbolinks visit
        presentVisitableForSession(session, URL: URL)
     
        // notification handler for detecting app foreground state
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        
        let sessionURL = session.webView.url?.absoluteString
        
        // maintain turbolinks cache/session UNLESS the following things occur!
    
        // check to see if the campus has changed from what was previously set in session, if it has... force a reload of the entire application
        if (sessionURL!.lowercased().range(of: campus) == nil) {
            presentVisitableForSession(session, URL: URL, action: .Replace)
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
    
    @objc func appMovedToForeground() {
        
        // FIX FOR NETWORK CONNECTION ERROR: reload the user's session when coming back to foreground.
        // For some reason, cached page (screenshot) is lost when coming back to foreground - causing the network error to display. The
        // workaround to to reload the session - forcing the entire app to basically refresh everything!
        // INVESTIGATE... for index.html head... use the 'no-preview' directive to opt out of snapshot previews?
        

        
        /* [Snapshotting] Snapshotting a view (0x1038ca800, Turbolinks.WebView) that is not in a visible window requires afterScreenUpdates:YES. */
        //session.reload()

        // only set user location if services are enabled
        if CLLocationManager.locationServicesEnabled() {
            print("moved to forground w/ location")
            setUserLocation()
        }
        else {
            
            // clear the user location
            location = ""
            
            // turbolinks visit with empty location
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

    
    func setUserLocation() {
        
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
            // Location services are available, so query the user’s location.
            // update user location variable and reload the URL
            location = "h_lat=\(locValue.latitude)&h_lng=\(locValue.longitude)"
            
        } else {
            // no location services... clear location
            location = ""
        }
        
        // turbolinks visit with user location
        // presentVisitableForSession(self.session, URL: self.URL, action: .Replace)
        
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
        
        print("sessionDidFinishRequest")
        // TODO: set the user location via evaljs... then trigger the spots to load!
        session.webView.evaluateJavaScript("Geolocation.set_location_using_bridge(12345, 54321)", completionHandler: nil)
        
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
