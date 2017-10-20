//
//  Error.swift
//  UW Scout
//
//  Copyright © 2017 UW-IT AXDD. All rights reserved.
//


struct Error {
    static let HTTPNotFoundError = Error(title: "Page Not Found", message: "There doesn’t seem to be anything here.")
    static let NetworkError = Error(title: "No Connection", message: "Seems like your internet connection is off. Click the Retry button to try again.")
    static let UnknownError = Error(title: "Unknown Error", message: "An unknown error occurred.")
    
    let title: String
    let message: String
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    init(HTTPStatusCode: Int) {
        self.title = "Server Error"
        self.message = "The server returned an HTTP \(HTTPStatusCode) response."
    }
}
