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
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInMiddleOfTyping{
            enter()
        }
        switch operation {
        case "+":performOperation({$0+$1})
        case "−":performOperation({$1-$0})
        case "×":performOperation({$1*$0})
        case "÷":performOperation({$1/$0})
        case "√":performOperation({sqrt($0)})
        default: break
        }
    }
    
    func performOperation(operation:(Double,Double) -> Double) {
        if(numberStack.count >= 2) {
            displayValue = operation(numberStack.removeLast(),numberStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation:(Double) -> Double) {
        if(numberStack.count >= 1) {
            displayValue = operation(numberStack.removeLast())
            enter()
        }
    }
    
    var numberStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInMiddleOfTyping = false
        numberStack.append(displayValue)
        print("\(numberStack)")
        
    }
    
    var displayValue:Double {
    
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set{
            display.text = "\(newValue)"
            userIsInMiddleOfTyping = false
        }
    }
}

