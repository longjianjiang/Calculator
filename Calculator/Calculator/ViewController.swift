//
//  ViewController.swift
//  Calculator
//
//  Created by longjianjiang on 2017/5/27.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var numberBtnArray: [UIButton] = []
    var funcitonBtnArray: [UIButton] = []
    
    
    var stackNumber:[String] = [] //operation number
    var stackSymbol:[String] = [] //operation symbol
    let symbols = [["+", "-"], ["x", "÷"]]
    
    var flag = false
    var memoryNumber: Float = 0.0
    
    lazy var displayLabel: LJLabel = {
        let label = LJLabel()
        label.verticalTextAligment = .bottom
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 100)
        label.textColor = UIColor.white
        label.text = "0"
        label.backgroundColor = UIColor.black
        return label
    }()
    
    lazy var mrBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.blue
        btn.setTitle("mr", for: .normal)
        btn.addTarget(self, action: #selector(showMemoryContent), for: .touchDown)
        return btn
    }()
    
    lazy var functionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    func showMemoryContent() {
        if memoryNumber > 0 {
            displayLabel.text = "\(memoryNumber)"
        }
    }
    
    func onlyInputTheNumber(_ string: String) -> Bool {
        let numString = "^[0-9]+(\\.[0-9]+)?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", numString)
        let number = predicate.evaluate(with: string)
        return number
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(displayLabel)
        self.view.addSubview(functionView)
        self.view.addSubview(mrBtn)

        displayLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self.view)
            make.height.equalTo(200)
        }
        functionView.snp.makeConstraints { (make) in
            make.top.equalTo(displayLabel.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view)
        }
        mrBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(20)
            make.leading.equalTo(self.view)
        }
        let functionBtnW = UIScreen.main.bounds.width / 4.0
        let functionBtnH = (UIScreen.main.bounds.height - 200) / 5.0
        let btnTitleArray = ["AC", "mc", "m+", "m-", "7", "8", "9", "÷", "4", "5", "6", "x", "1", "2", "3", "-", "0", ".", "=", "+"]
        
        for index in 0..<20 {
            let btn = UIButton(type: .custom)
            btn.layer.borderColor =  UIColor(colorLiteralRed: 142/255.0, green: 142/255.0, blue: 142/255.0, alpha: 1.0).cgColor
            btn.layer.borderWidth = 0.5
            btn.setTitle(btnTitleArray[index], for: .normal)
            
            
            functionView.addSubview(btn)
            let i = (CGFloat)(index)
            let num = (CGFloat)(index % 4)
            let num1 = (CGFloat)(index/4)
            
            if index < 4 {
                funcitonBtnArray.append(btn)
            } else if index < 16{
                if num<3 {
                    numberBtnArray.append(btn)
                    btn.backgroundColor = UIColor(colorLiteralRed: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0)
                } else {
                    funcitonBtnArray.append(btn)
                }
            } else {
                if index <= 17 {
                    numberBtnArray.append(btn)
                    btn.backgroundColor = UIColor(colorLiteralRed: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0)
                    
                } else {
                    funcitonBtnArray.append(btn)
                }
            }
            
            
            if index/4 < 1 {
                btn.frame = CGRect(x: i*functionBtnW, y: num1*functionBtnH, width: functionBtnW, height: functionBtnH)
            } else if index/4 < 2 {
                btn.frame = CGRect(x: num*functionBtnW , y: num1*functionBtnH, width: functionBtnW, height: functionBtnH)
            } else if index/4 < 3 {
                btn.frame = CGRect(x: num*functionBtnW , y: num1*functionBtnH, width: functionBtnW, height: functionBtnH)
            } else if index/4 < 4 {
                btn.frame = CGRect(x: num*functionBtnW , y: num1*functionBtnH, width: functionBtnW, height: functionBtnH)
            } else {
                btn.frame = CGRect(x: num*functionBtnW , y: num1*functionBtnH, width: functionBtnW, height: functionBtnH)
            }
        }
        
        for item in numberBtnArray {
            item.addTarget(self, action: #selector(numberBtnClick(_:)), for: .touchDown)
            item.addTarget(self, action: #selector(touchEnded(_:)), for: .touchUpInside)
            item.addTarget(self, action: #selector(touchEnded(_:)), for: .touchUpOutside)
            
        }
        
        for item in funcitonBtnArray {
            item.addTarget(self, action: #selector(functionBtnClick(_:)), for: .touchDown)
            item.addTarget(self, action: #selector(touchEnded(_:)), for: .touchUpInside)
            item.addTarget(self, action: #selector(touchEnded(_:)), for: .touchUpOutside)
            
        }
        
    }
    
    
    func touchEnded(_ btn: UIButton) {
        btn.alpha = 1.0
    }
    func numberBtnClick(_ btn: UIButton) {
        btn.alpha = 0.4
        
        if flag {
            displayLabel.text = "0"
            flag = false
        }
        
        if self.displayLabel.text == "0" {
            if btn.titleLabel?.text != "0" {
                self.displayLabel.text = btn.titleLabel?.text
            }
        } else {
            displayLabel.text = displayLabel.text?.appending((btn.titleLabel?.text)!)
        }
        
    }
    
    
    func isGreat(_ para1: String, _ para2: String) -> Bool {
        var index1: Int = 0
        var index2: Int = 0
        for (index, item) in symbols.enumerated() {
            for num in item {
                if num == para1 {
                    index1 = index
                }
                if num == para2 {
                    index2 = index
                }
            }
        }
        
        if index1 > index2 {
            return true
        } else {
            return false
        }
    }
    
    func functionBtnClick(_ btn: UIButton) {
        btn.alpha = 0.8
        stackNumber.append(displayLabel.text!)
        
        
        if btn.titleLabel?.text == "AC" {
            self.displayLabel.text = "0"
            stackNumber.removeAll()
            stackSymbol.removeAll()
        }
        
        
        if btn.titleLabel?.text == "mc" {
            memoryNumber = 0.0
        }
        
        if btn.titleLabel?.text == "m+" {
            let num = (Float)(displayLabel.text!)
            memoryNumber = num! + memoryNumber
        }
        
        if btn.titleLabel?.text == "m-" {
            let num = (Float)(displayLabel.text!)
            memoryNumber = memoryNumber - num!
        }
        
        
        if btn.titleLabel?.text == "+" || btn.titleLabel?.text == "-" || btn.titleLabel?.text == "x" || btn.titleLabel?.text == "÷"  {
            flag = true
            if stackSymbol.count == 0 {
                stackSymbol.append((btn.titleLabel?.text)!)
            } else {
                if isGreat((btn.titleLabel?.text)!, stackSymbol.last!) { // 当前输入的操作符优先级大于栈顶操作符
                    stackSymbol.append((btn.titleLabel?.text)!)
                } else {
                    stackNumber.append(stackSymbol.last!)
                    stackSymbol.remove(at: stackSymbol.count-1)
                    stackSymbol.append((btn.titleLabel?.text)!)
                }
            }
        }
        
        
        if btn.titleLabel?.text == "=" {
            if stackSymbol.count > 0 {
                for item in stackSymbol.reversed() {
                    stackNumber.append(item)
                }
            }
            var result: [Float] = []
            
            for item in stackNumber {
                if onlyInputTheNumber(item){
                    let num = (Float)(item)
                    result.append(num!)
                } else {
                    if item == "+" {
                        if result.count >= 2 {
                            let num = (Float)(result[result.count-2]) + (Float)(result[result.count-1])
                            result.remove(at: result.count-1)
                            result.remove(at: result.count-1)
                            result.append(num)
                        }
                    }
                    if item == "-" {
                        if result.count >= 2 {
                            let num = (Float)(result[result.count-2]) - (Float)(result[result.count-1])
                            result.remove(at: result.count-1)
                            result.remove(at: result.count-1)
                            result.append(num)
                        }
                    }
                    if item == "x" {
                        if result.count >= 2 {
                            let num = (Float)(result[result.count-2]) * (Float)(result[result.count-1])
                            result.remove(at: result.count-1)
                            result.remove(at: result.count-1)
                            result.append(num)
                        }
                    }
                    if item == "÷" {
                        if result.count >= 2 {
                            let num = (Float)(result[result.count-2]) / (Float)(result[result.count-1])
                            result.remove(at: result.count-1)
                            result.remove(at: result.count-1)
                            result.append(num)
                        }
                    }
                }
            }
            if (result.last == (6/0)) {
                displayLabel.text = "Error"
            } else {
                displayLabel.text = "\(result.last!)"
            }
            
            stackSymbol.removeAll()
        }
        
    }
    
}


