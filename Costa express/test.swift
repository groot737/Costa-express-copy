//
//  test.swift
//  Costa express
//
//  Created by giorgi quchuloria on 8/30/22.
//  Copyright © 2022 Gai. All rights reserved.
//

import Foundation
import UIKit

class test: UIViewController {
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var stop: UIButton!
    
    @IBAction func start(_ sender: UIButton) {
        start.isHidden = true
        stop.isHidden = false
    }
    @IBAction func stop(_ sender: UIButton) {
        start.isHidden = true
        stop.isHidden = true
    }
}
