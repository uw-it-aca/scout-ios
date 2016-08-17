//
//  FoodViewController.swift
//  Scout
//
//  Created by Charlon Palacay on 4/6/16.
//  Copyright © 2016 Charlon Palacay. All rights reserved.
//

import UIKit

class FoodViewController: ApplicationController {
    
    override var URL: NSURL {
        return NSURL(string: "\(host)/food/")!
    }
    
}