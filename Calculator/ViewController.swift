//
//  ViewController.swift
//  Calculator
//
//  Created by guoliangwei on 2/2/15.
//  Copyright (c) 2015 GLW1900. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    var userIsInMiddleOfTyping = false
    var decimalMark = false
    
    @IBAction func digit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(digit != "." || decimalMark == false) {
            addNumber(digit)
            if(digit == ".") {decimalMark = true}
        }
    }

    func addNumber(digit: String) {
        if userIsInMiddleOfTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInMiddleOfTyping = true
        }
    }
    
    @IBAction func clear() {
        displayValue = 0
        numberStack = []
        history.text = ""
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInMiddleOfTyping{
            addHistory()
            enter()
        }
        historyOperation = operation
        switch operation {
        case "+":performOperation({$0+$1})
        case "−":performOperation({$1-$0})
        case "×":performOperation({$1*$0})
        case "÷":performOperation({$1/$0})
        case "√":performOperation({sqrt($0)})
        case "sin":performOperation({sin($0)})
        case "cos":performOperation({cos($0)})
        case "π":
            let x = M_PI
            displayValue = x
            enter()
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
    
    
    @IBAction func addHistory() {
        if(userIsInMiddleOfTyping == true){
            historyOperation = "\(displayValue)"
        }
    }
    
    @IBAction func enter() {
        userIsInMiddleOfTyping = false
        decimalMark = false
        numberStack.append(displayValue)
        print("\(numberStack)")
        
    }
    
    var historyOperation:String {
        set{
            history.text! = history.text! + " \(newValue)"
        }
        get {
            return history.text!
        }
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

