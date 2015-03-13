//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by guoliangwei on 2/22/15.
//  Copyright (c) 2015 GLW1900. All rights reserved.
//

import Foundation

class Calculator {
    
    private enum Op : Printable {
        case Operand(Double)
        case OneOperation(String, Double -> Double)
        case TwoOperation(String, (Double,Double) -> Double)
        case Variable(String)
        
        var description:String {
            
            get {
                switch self {
                case .Operand(let number):
                    return "\(number)"
                case .OneOperation(let operation, _):
                    return operation
                case .TwoOperation(let operation, _):
                    return operation
                case .Variable(let str):
                    return str
                }
            }
        }
    
    }
    
    var variableValues = [String:Double]()
    
    private var OpStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    var description:String {
        get {
            var result = ""
            var stack = OpStack
            var temp = ""
            while stack.count > 0 {
                (temp,stack) = describe(stack)
                result = result + ", " + temp
            }
            return result
        }
    }
    
    private func describe(stack:[Op]) -> (result:String,stack:[Op]){
        var remaining = stack
        let operation = remaining.removeLast()
        switch operation {
        case .Operand(let number):
            return ("\(number)", remaining)
        case .OneOperation(let oper,_):
            if remaining.count > 0 {
                let desEva = describe(remaining)
                let operand = desEva.result
                return (oper+"("+operand+")",desEva.stack)
            }
        case .TwoOperation(let oper, _):
            if remaining.count > 1 {
                let opEva1 = describe(remaining)
                let op1 = opEva1.result
                let opEva2 = describe(opEva1.stack)
                let op2 = opEva2.result
                return(op2+oper+op1,opEva2.stack)
            }
        case .Variable(let variable):
            return (variable,remaining)
        }
        return ("?",remaining)
    }
    
    
    
    init() {
        knownOps["+"] = Op.TwoOperation("+", +)
        knownOps["−"] = Op.TwoOperation("−", {$1 - $0})
        knownOps["×"] = Op.TwoOperation("×", *)
        knownOps["÷"] = Op.TwoOperation("÷", {$1/$0})
        knownOps["√"] = Op.OneOperation("√", sqrt)
        knownOps["sin"] = Op.OneOperation("sin", sin)
        knownOps["cos"] = Op.OneOperation("cos", cos)
        knownOps["π"] = Op.OneOperation("π", {M_PI*$0})
    }
    
    func evaluate() -> Double? {
        let (result,remaining) = evaluate(OpStack)
        return result
    }
    
    private func evaluate(ops: [Op]) -> (result:Double?, remainingOps:[Op]){
        if !ops.isEmpty {
            var remaining = ops
            let operation = remaining.removeLast()
            switch operation {
            case .Operand(let number):
                return (number,remaining)
            case .OneOperation(_,let oneOp):
                let operandEva = evaluate(remaining)
                if let operand = operandEva.result {
                    return (oneOp(operand),operandEva.remainingOps)
                }
            case .TwoOperation(_, let twoOp):
                let operandEva1 = evaluate(remaining)
                if let operand1 = operandEva1.result {
                    let operandEva2 = evaluate(operandEva1.remainingOps)
                    if let operand2 = operandEva2.result {
                        return (twoOp(operand1,operand2), operandEva2.remainingOps)
                    }
                }
            case .Variable(let variable):
                return (variableValues[variable],remaining)
            }
        }
        return (nil,ops)
    }
    
    func pushOperand(operand:Double?) -> Double? {
        if let operand = operand {
            OpStack.append(Op.Operand(operand))
            return evaluate()
        }
        return nil
    }
    
    func pushOperand(symbol: String) -> Double? {
        OpStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol:String) -> Double? {
        if let operation = knownOps[symbol] {
            OpStack.append(operation)
        }
        return evaluate()
    }
    
    func refresh() {
        OpStack = []
        variableValues = [:]
    }
}