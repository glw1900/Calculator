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
    
    var calculatorBrain = Calculator()
    
    @IBAction func digit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(digit != "." || decimalMark == false) {
            addNumber(digit)
            if(digit == ".") {decimalMark = true}
        }
    }
    
    @IBAction func pushValue(sender: UIButton) {
        calculatorBrain.pushOperand("M")
        if let result = calculatorBrain.evaluate() {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func setValue(sender: UIButton) {
        if displayValue != nil {
            calculatorBrain.variableValues["M"] = displayValue
            userIsInMiddleOfTyping = false
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
        display.text = ""
        history.text = ""
        calculatorBrain.refresh()
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInMiddleOfTyping{
            addHistory()
            enter()
        }
        
        historyOperation = sender.currentTitle!
        if let operation = sender.currentTitle {
            if let result = calculatorBrain.performOperation(operation) {
                displayValue = result
            }
            else {displayValue = nil}
        }
    }
    
    @IBAction func addHistory() {
        if(userIsInMiddleOfTyping == true){
            historyOperation = "\(displayValue!)"
        }
    }
    
    @IBAction func enter() {
        userIsInMiddleOfTyping = false
        decimalMark = false
        if let result = calculatorBrain.pushOperand(displayValue!) {
                displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    var historyOperation:String {
        set{
            history.text! = calculatorBrain.description + "="
        }
        get {
            return history.text!
        }
    }
    
    var displayValue: Double? {
    
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set{
            if newValue == nil {
                clear()
                display.text = "Error"
                userIsInMiddleOfTyping = false
                return
            }
            display.text = "\(newValue!)"
            userIsInMiddleOfTyping = false
        }
    }
}

