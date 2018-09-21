//
//  ErrorView.swift
//  UW Scout
//
//  Copyright © 2017 UW-IT AXDD. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var retryButton: UIButton!
    
    var error: Error? {
        didSet {
            titleLabel.text = error?.title
            messageLabel.text = error?.message
            retryButton.setTitle(error?.button, for: .normal)
        }
    }
}
