//
//  DistanceViewController.swift
//  UtilityConvertor
//
//  Created by Vinojini Paramasivam on 21/3/8.
//

import UIKit

let DISTANCE_USER_DEFAULTS_KEY = "distance"
private let DISTANCE_USER_DEFAULTS_MAX_COUNT = 5

class DistanceConversionVC: UIViewController, CustomNumericKeyboardDelegate {
    
    @IBOutlet weak var viewScroller: UIScrollView!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var outerStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var meterTextField: UITextField!
    @IBOutlet weak var meterTextFieldStackView: UIStackView!
    @IBOutlet weak var centimeterTextField: UITextField!
    @IBOutlet weak var centimeterTextFieldStackView: UIStackView!
    @IBOutlet weak var millimeterTextField: UITextField!
    @IBOutlet weak var millimeterTextFieldStackView: UIStackView!
    @IBOutlet weak var mileTextField: UITextField!
    @IBOutlet weak var mileTextFieldStackView: UIStackView!
    @IBOutlet weak var yardTextField: UITextField!
    @IBOutlet weak var yardTextFieldStackView: UIStackView!
    @IBOutlet weak var inchTextField: UITextField!
    @IBOutlet weak var inchTextFieldStackView: UIStackView!
    
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
        
        // Set Text Field Styles
        meterTextField._lightPlaceholderColor(UIColor.lightText)
        meterTextField.setAsNumericKeyboard(delegate: self)
        
        centimeterTextField._lightPlaceholderColor(UIColor.lightText)
        centimeterTextField.setAsNumericKeyboard(delegate: self)
        
        millimeterTextField._lightPlaceholderColor(UIColor.lightText)
        millimeterTextField.setAsNumericKeyboard(delegate: self)
        
        mileTextField._lightPlaceholderColor(UIColor.lightText)
        mileTextField.setAsNumericKeyboard(delegate: self)
        
        yardTextField._lightPlaceholderColor(UIColor.lightText)
        yardTextField.setAsNumericKeyboard(delegate: self)
        
        inchTextField._lightPlaceholderColor(UIColor.lightText)
        inchTextField.setAsNumericKeyboard(delegate: self)
        
        // ad an observer to track keyboard show event
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
                
                var contentInset:UIEdgeInsets = self.viewScroller.contentInset
                contentInset.bottom = keyboard.size.height
                viewScroller.contentInset = contentInset
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
        var unit: DistanceUnit?
        
        if textField.tag == 1 {
            unit = DistanceUnit.meter
        } else if textField.tag == 2 {
            unit = DistanceUnit.centimeter
        } else if textField.tag == 3 {
            unit = DistanceUnit.millimeter
        } else if textField.tag == 4 {
            unit = DistanceUnit.mile
        } else if textField.tag == 5 {
            unit = DistanceUnit.yard
        } else if textField.tag == 6 {
            unit = DistanceUnit.inch
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
            let conversion = "\(meterTextField.text!) m = \(centimeterTextField.text!) cm = \(millimeterTextField.text!) mm = \(mileTextField.text!) miles = \(yardTextField.text!) yards = \(inchTextField.text!) inches"
            
            var arr = UserDefaults.standard.array(forKey: DISTANCE_USER_DEFAULTS_KEY) as? [String] ?? []
            
            if arr.count >= DISTANCE_USER_DEFAULTS_MAX_COUNT {
                arr = Array(arr.suffix(DISTANCE_USER_DEFAULTS_MAX_COUNT - 1))
            }
            arr.append(conversion)
            UserDefaults.standard.set(arr, forKey: DISTANCE_USER_DEFAULTS_KEY)
            
            let alert = UIAlertController(title: "Success", message: "The distance conversion was successully saved!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "You are trying to save an empty conversion!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isTextFieldsEmpty() -> Bool {
        if !(meterTextField.text?.isEmpty)! && !(centimeterTextField.text?.isEmpty)! &&
            !(millimeterTextField.text?.isEmpty)! && !(mileTextField.text?.isEmpty)! &&
            !(yardTextField.text?.isEmpty)! && !(inchTextField.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    func updateTextFields(textField: UITextField, unit: DistanceUnit) -> Void {
        if let input = textField.text {
            if input.isEmpty {
                clearTextFields()
            } else {
                if let value = Double(input as String) {
                    let distance = Distance(unit: unit, value: value)
                    
                    for _unit in DistanceUnit.getAllUnits {
                        if _unit == unit {
                            continue
                        }
                        let textField = mapUnitToTextField(unit: _unit)
                        let result = distance.convert(unit: _unit)
                        
                        //rounding off to 4 decimal places
                        let roundedResult = Double(round(10000 * result) / 10000)
                        
                        textField.text = String(roundedResult)
                    }
                }
            }
        }
    }
    

    func mapUnitToTextField(unit: DistanceUnit) -> UITextField {
        var textField = meterTextField
        switch unit {
        case .meter:
            textField = meterTextField
        case .centimeter:
            textField = centimeterTextField
        case .millimeter:
            textField = millimeterTextField
        case .mile:
            textField = mileTextField
        case .yard:
            textField = yardTextField
        case .inch:
            textField = inchTextField
        }
        return textField!
    }
    
    func clearTextFields() {
        meterTextField.text = ""
        centimeterTextField.text = ""
        millimeterTextField.text = ""
        mileTextField.text = ""
        yardTextField.text = ""
        inchTextField.text = ""
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
