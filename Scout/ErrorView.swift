//
//  ErrorView.swift
//  Scout
//
//  Created by Charlon Palacay on 4/6/16.
//  Copyright © 2016 Charlon Palacay. All rights reserved.
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
        }
    }
}