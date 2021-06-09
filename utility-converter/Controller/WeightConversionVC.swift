//
//  TemperatureViewController.swift
//  UtilityConvertor
//
//  Created by Vinojini Paramasivam on 21/3/8.
//

import UIKit

let WEIGHTS_USER_DEFAULTS_KEY = "weight"
private let WEIGHTS_USER_DEFAULTS_MAX_COUNT = 5

class WeightConversionVC: UIViewController, CustomNumericKeyboardDelegate {
    
    @IBOutlet weak var weightViewScroller: UIScrollView!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var outerStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var kilogramTextField: UITextField!
    @IBOutlet weak var kilogramTextFieldStackView: UIStackView!
    @IBOutlet weak var gramTextField: UITextField!
    @IBOutlet weak var gramTextFieldStackView: UIStackView!
    @IBOutlet weak var ounceTextField: UITextField!
    @IBOutlet weak var ounceTextFieldStackView: UIStackView!
    @IBOutlet weak var poundTextField: UITextField!
    @IBOutlet weak var poundsTextFieldStackView: UIStackView!
    @IBOutlet weak var spStoneTextField: UITextField!
    @IBOutlet weak var spPoundTextField: UITextField!
    @IBOutlet weak var spTextFieldStackView: UIStackView!
    
    var activeTextField = UITextField()
    var outerStackViewTopConstraintDefaultHeight: CGFloat = 17.0
    var textFieldKeyBoardGap = 20
    var keyBoardHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide)))
        
        if isTextFieldsEmpty() {
            self.navigationItem.rightBarButtonItem!.isEnabled = false;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        kilogramTextField._lightPlaceholderColor(UIColor.lightText)
        kilogramTextField.setAsNumericKeyboard(delegate: self)
        
        gramTextField._lightPlaceholderColor(UIColor.lightText)
        gramTextField.setAsNumericKeyboard(delegate: self)
        
        ounceTextField._lightPlaceholderColor(UIColor.lightText)
        ounceTextField.setAsNumericKeyboard(delegate: self)
        
        poundTextField._lightPlaceholderColor(UIColor.lightText)
        poundTextField.setAsNumericKeyboard(delegate: self)
        
        spStoneTextField._lightPlaceholderColor(UIColor.lightText)
        spStoneTextField.setAsNumericKeyboard(delegate: self)
        
        spPoundTextField._lightPlaceholderColor(UIColor.lightText)
        spPoundTextField.setAsNumericKeyboard(delegate: self)
        spPoundTextField.isUserInteractionEnabled = false // disable the interactivity
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillHide() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.outerStackViewTopConstraint.constant = self.outerStackViewTopConstraintDefaultHeight
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let firstResponder = self.findFirstResponder(inView: self.view)
        
        if firstResponder != nil {
            activeTextField = firstResponder as! UITextField;
            
            var activeTextFieldSuperView = activeTextField.superview!
            
            if activeTextField.tag == 5 || activeTextField.tag == 6 {
                activeTextFieldSuperView = activeTextField.superview!.superview!
            }
            
            if let info = notification.userInfo {
                let keyboard:CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
                
                let targetY = view.frame.size.height - keyboard.height - 15 - activeTextField.frame.size.height
                
                let initialY = outerStackView.frame.origin.y + activeTextFieldSuperView.frame.origin.y + activeTextField.frame.origin.y
                
                if initialY > targetY {
                    let diff = targetY - initialY
                    let targetOffsetForTopConstraint = outerStackViewTopConstraint.constant + diff
                    self.view.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.outerStackViewTopConstraint.constant = targetOffsetForTopConstraint
                        self.view.layoutIfNeeded()
                    })
                }
                
                var contentInset:UIEdgeInsets = self.weightViewScroller.contentInset
                contentInset.bottom = keyboard.size.height
                weightViewScroller.contentInset = contentInset
            }
        }
    }
    
    func findFirstResponder(inView view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder {
                return subView
            }
            
            if let recursiveSubView = self.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }
        
        return nil
    }
    
    @IBAction func handleTextFieldChange(_ textField: UITextField) {
        var unit: WeightUnit?
        
        if textField.tag == 1 {
            unit = WeightUnit.kilogram
        } else if textField.tag == 2 {
            unit = WeightUnit.gram
        } else if textField.tag == 3 {
            unit = WeightUnit.ounce
        } else if textField.tag == 4 {
            unit = WeightUnit.pound
        } else if textField.tag == 5 {
            unit = WeightUnit.stone
        } else if textField.tag == 6 {
            unit = WeightUnit.stone
        }
        
        if unit != nil {
            updateTextFields(textField: textField, unit: unit!)
        }
        
        if isTextFieldsEmpty() {
            self.navigationItem.rightBarButtonItem!.isEnabled = false;
        } else {
            self.navigationItem.rightBarButtonItem!.isEnabled = true;
        }
    }

    @IBAction func handleSaveButtonClick(_ sender: UIBarButtonItem) {
        if !isTextFieldsEmpty() {
            let conversion = "\(kilogramTextField.text!) kg = \(gramTextField.text!) g = \(ounceTextField.text!) oz =  \(poundTextField.text!) lb = \(spStoneTextField.text!) stones & \(spPoundTextField.text!) pounds"
            
            var arr = UserDefaults.standard.array(forKey: WEIGHTS_USER_DEFAULTS_KEY) as? [String] ?? []
            
            if arr.count >= WEIGHTS_USER_DEFAULTS_MAX_COUNT {
                arr = Array(arr.suffix(WEIGHTS_USER_DEFAULTS_MAX_COUNT - 1))
            }
            arr.append(conversion)
            UserDefaults.standard.set(arr, forKey: WEIGHTS_USER_DEFAULTS_KEY)
            
            let alert = UIAlertController(title: "Success", message: "The weight conversion was successully saved!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "You are trying to save an empty conversion!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    func isTextFieldsEmpty() -> Bool {
        if !(kilogramTextField.text?.isEmpty)! && !(gramTextField.text?.isEmpty)! &&
            !(ounceTextField.text?.isEmpty)! && !(poundTextField.text?.isEmpty)! &&
            !(spStoneTextField.text?.isEmpty)! && !(spPoundTextField.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    func updateTextFields(textField: UITextField, unit: WeightUnit) -> Void {
        if let input = textField.text {
            if input.isEmpty {
                clearTextFields()
            } else {
                if let value = Double(input as String) {
                    let weight = Weight(unit: unit, value: value)
                    
                    for _unit in WeightUnit.getAllUnits {
                        if _unit == unit {
                            continue
                        }
                        let textField = mapUnitToTextField(unit: _unit)
                        let result = weight.convert(unit: _unit)
                        
                        //rounding off to 4 decimal places
                        let roundedResult = Double(round(10000 * result) / 10000)
                        
                        textField.text = String(roundedResult)
                        moderateStonePounds()
                    }
                }
            }
        }
    }

    func moderateStonePounds() {
        if let textFieldVal = spStoneTextField.text {
            if let value = Double(textFieldVal as String) {
                let integerPart = Int(value)
                let decimalPart = value.truncatingRemainder(dividingBy: 1)
                let poundValue = decimalPart * 14
                
                spStoneTextField.text = String(integerPart)
                spPoundTextField.text = String(Double(round(10000 * poundValue) / 10000))
            }
        }
    }
    
    func mapUnitToTextField(unit: WeightUnit) -> UITextField {
        var textField = kilogramTextField
        switch unit {
        case .kilogram:
            textField = kilogramTextField
        case .gram:
            textField = gramTextField
        case .ounce:
            textField = ounceTextField
        case .pound:
            textField = poundTextField
        case .stone:
            textField = spStoneTextField
        }
        return textField!
    }
    
    func clearTextFields() {
        kilogramTextField.text = ""
        gramTextField.text = ""
        ounceTextField.text = ""
        poundTextField.text = ""
        spStoneTextField.text = ""
        spPoundTextField.text = ""
    }
    

    func retractKeyPressed() {
        keyboardWillHide()
    }
    

    func numericKeyPressed(key: Int) {
        print("Numeric key \(key) pressed!")
    }
    
    func numericBackspacePressed() {
        print("Backspace pressed!")
    }
    
    func numericSymbolPressed(symbol: String) {
        print("Symbol \(symbol) pressed!")
    }
}

extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
