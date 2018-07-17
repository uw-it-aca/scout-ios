//
//  Error.swift
//  Scout
//
//  Created by Charlon Palacay on 4/6/16.
//  Copyright © 2016 Charlon Palacay. All rights reserved.
//

struct Error {
    static let HTTPNotFoundError = Error(title: "Page Not Found", message: "There doesn’t seem to be anything here.", button: "Retry")
    static let NetworkError = Error(title: "Temporarily Not Available", message: "The content you requested was not loaded due to a network connection error. Re-connect to a network and try reloading.", button: "RELOAD")
    static let UnknownError = Error(title: "Unknown Error", message: "An unknown error occurred.", button: "Retry")
    
    let title: String
    let message: String
    let button: String
    
    init(title: String, message: String, button: String) {
        self.title = title
        self.message = message
        self.button = button
    }
    
    init(HTTPStatusCode: Int) {
        self.title = "Server Error"
        self.message = "The server returned an HTTP \(HTTPStatusCode) response."
        self.button = "Retry"
    }
}
