//
//  Error.swift
//  UW Scout
//
//  Copyright © 2017 UW-IT AXDD. All rights reserved.
//


struct Error {
    static let HTTPNotFoundError = Error(title: "Page Not Found", message: "There doesn’t seem to be anything here.", button: "Retry")
    static let NetworkError = Error(title: "No Connection", message: "You don't seem to be connected to the internet.", button: "Try again to connect")
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
