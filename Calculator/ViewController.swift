//
//  ViewController.swift
//  Calculator
//
//  Created by guoliangwei on 2/2/15.
//  Copyright (c) 2015 GLW1900. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var userIsInMiddleOfTyping: Bool = false
    
    @IBAction func digit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInMiddleOfTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInMiddleOfTyping = true
        }
        
        
    }
    

}

