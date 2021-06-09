//
//  SpeedConversionViewController.swift
//  UtilityConvertor
//
//  Created by Vinojini Paramasivam on 21/3/8.
//

import UIKit

let SPEED_USER_DEFAULTS_KEY = "speed"
private let SPEED_USER_DEFAULTS_MAX_COUNT = 5

class SpeedConversionVC: UIViewController, CustomNumericKeyboardDelegate {
    
    @IBOutlet weak var speedViewScroller: UIScrollView!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var outerStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var msTextField: UITextField!
    @IBOutlet weak var msTextFieldStackView: UIStackView!
    @IBOutlet weak var kmhTextField: UITextField!
    @IBOutlet weak var kmhTextFieldStackView: UIStackView!
    @IBOutlet weak var mihTextField: UITextField!
    @IBOutlet weak var mihTextFieldStackView: UIStackView!
    @IBOutlet weak var knTextField: UITextField!
    @IBOutlet weak var knTextFieldStackView: UIStackView!
    
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
        
        msTextField._lightPlaceholderColor(UIColor.lightText)
        msTextField.setAsNumericKeyboard(delegate: self)
        
        kmhTextField._lightPlaceholderColor(UIColor.lightText)
        kmhTextField.setAsNumericKeyboard(delegate: self)
        
        mihTextField._lightPlaceholderColor(UIColor.lightText)
        mihTextField.setAsNumericKeyboard(delegate: self)
        
        knTextField._lightPlaceholderColor(UIColor.lightText)
        knTextField.setAsNumericKeyboard(delegate: self)
        
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
            
            let activeTextFieldSuperView = activeTextField.superview!
            
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
                
                var contentInset:UIEdgeInsets = self.speedViewScroller.contentInset
                contentInset.bottom = keyboard.size.height
                speedViewScroller.contentInset = contentInset
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
        var unit: SpeedUnit?
        
        if textField.tag == 1 {
            unit = SpeedUnit.ms
        } else if textField.tag == 2 {
            unit = SpeedUnit.kmh
        } else if textField.tag == 3 {
            unit = SpeedUnit.mih
        } else if textField.tag == 4 {
            unit = SpeedUnit.kn
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
            let conversion = "\(msTextField.text!) ms/s = \(kmhTextField.text!) km/h = \(mihTextField.text!) mi/h = \(knTextField.text!) knots"
            
            var arr = UserDefaults.standard.array(forKey: SPEED_USER_DEFAULTS_KEY) as? [String] ?? []
            
            if arr.count >= SPEED_USER_DEFAULTS_MAX_COUNT {
                arr = Array(arr.suffix(SPEED_USER_DEFAULTS_MAX_COUNT - 1))
            }
            arr.append(conversion)
            UserDefaults.standard.set(arr, forKey: SPEED_USER_DEFAULTS_KEY)
            
            let alert = UIAlertController(title: "Success", message: "The speed conversion was successully saved!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "You are trying to save an empty conversion!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isTextFieldsEmpty() -> Bool {
        if !(msTextField.text?.isEmpty)! && !(kmhTextField.text?.isEmpty)! &&
            !(mihTextField.text?.isEmpty)! && !(knTextField.text?.isEmpty)!{
            return false
        }
        return true
    }

    func updateTextFields(textField: UITextField, unit: SpeedUnit) -> Void {
        if let input = textField.text {
            if input.isEmpty {
                clearTextFields()
            } else {
                if let value = Double(input as String) {
                    let speed = Speed(unit: unit, value: value)
                    
                    for _unit in SpeedUnit.getAllUnits {
                        if _unit == unit {
                            continue
                        }
                        let textField = mapUnitToTextField(unit: _unit)
                        let result = speed.convert(unit: _unit)
                        
                        //rounding off to 4 decimal places
                        let roundedResult = Double(round(10000 * result) / 10000)
                        
                        textField.text = String(roundedResult)
                    }
                }
            }
        }
    }

    func mapUnitToTextField(unit: SpeedUnit) -> UITextField {
        var textField = msTextField
        switch unit {
        case .ms:
            textField = msTextField
        case .kmh:
            textField = kmhTextField
        case .mih:
            textField = mihTextField
        case .kn:
            textField = knTextField
        }
        return textField!
    }
    

    func clearTextFields() {
        msTextField.text = ""
        kmhTextField.text = ""
        mihTextField.text = ""
        knTextField.text = ""
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
