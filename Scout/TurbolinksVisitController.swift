//
//  TurbolinksVisitController.swift
//  UW Scout
//
//  Created by Charlon Palacay on 1/5/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import Turbolinks
import UIKit

class TurbolinksVisitController: Turbolinks.VisitableViewController {
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
        reloadVisitable()
    }
    
    override func visitableDidRender() {
        print("visitableDidRender")
        print("evaluateJavaScript: pass global location to hybrid")
        
        // pass global saved location using js evaluation
        visitableView.webView!.evaluateJavaScript("Geolocation.set_location_using_bridge(\(user_lat), \(user_lng))", completionHandler: nil)
        // default campus location
        // session.webView.evaluateJavaScript("Geolocation.set_location_using_bridge(47.653811, -122.307815)", completionHandler: nil)
        
    }
    
}
