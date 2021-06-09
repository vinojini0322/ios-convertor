//
//  VolumeViewController.swift
//  UtilityConvertor
//
//  Created by Vinojini Paramasivam on 21/3/8.
//
import UIKit

let VOLUME_USER_DEFAULTS_KEY = "volume"
private let VOLUME_USER_DEFAULTS_MAX_COUNT = 5

class VolumeConversionVC: UIViewController, CustomNumericKeyboardDelegate {
    
    @IBOutlet weak var volumeViewScroller: UIScrollView!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var outerStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var litreTextField: UITextField!
    @IBOutlet weak var litreTextFieldStackView: UIStackView!
    @IBOutlet weak var millilitreTextField: UITextField!
    @IBOutlet weak var millilitreTextFieldStackView: UIStackView!
    @IBOutlet weak var gallonTextField: UITextField!
    @IBOutlet weak var gallonTextFieldStackView: UIStackView!
    @IBOutlet weak var pintTextField: UITextField!
    @IBOutlet weak var pintTextFieldStackView: UIStackView!
    @IBOutlet weak var fluidOunceTextField: UITextField!
    @IBOutlet weak var fluidOunceTextFieldStackView: UIStackView!
    
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
        litreTextField._lightPlaceholderColor(UIColor.lightText)
        litreTextField.setAsNumericKeyboard(delegate: self)
        
        millilitreTextField._lightPlaceholderColor(UIColor.lightText)
        millilitreTextField.setAsNumericKeyboard(delegate: self)
        
        gallonTextField._lightPlaceholderColor(UIColor.lightText)
        gallonTextField.setAsNumericKeyboard(delegate: self)
        
        pintTextField._lightPlaceholderColor(UIColor.lightText)
        pintTextField.setAsNumericKeyboard(delegate: self)
        
        fluidOunceTextField._lightPlaceholderColor(UIColor.lightText)
        fluidOunceTextField.setAsNumericKeyboard(delegate: self)
        
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
                
                var contentInset:UIEdgeInsets = self.volumeViewScroller.contentInset
                contentInset.bottom = keyboard.size.height
                volumeViewScroller.contentInset = contentInset
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
        var unit: VolumeUnit?
        
        if textField.tag == 1 {
            unit = VolumeUnit.litre
        } else if textField.tag == 2 {
            unit = VolumeUnit.millilitre
        } else if textField.tag == 3 {
            unit = VolumeUnit.gallon
        } else if textField.tag == 4 {
            unit = VolumeUnit.pint
        } else if textField.tag == 5 {
            unit = VolumeUnit.fluidOunce
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
            let conversion = "\(litreTextField.text!) L = \(millilitreTextField.text!) ml = \(gallonTextField.text!) gal = \(pintTextField.text!) pints = \(fluidOunceTextField.text!) fl oz"
            
            var arr = UserDefaults.standard.array(forKey: VOLUME_USER_DEFAULTS_KEY) as? [String] ?? []
            
            if arr.count >= VOLUME_USER_DEFAULTS_MAX_COUNT {
                arr = Array(arr.suffix(VOLUME_USER_DEFAULTS_MAX_COUNT - 1))
            }
            arr.append(conversion)
            UserDefaults.standard.set(arr, forKey: VOLUME_USER_DEFAULTS_KEY)
            
            let alert = UIAlertController(title: "Success", message: "The volume conversion was successully saved!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "You are trying to save an empty conversion!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    func isTextFieldsEmpty() -> Bool {
        if !(litreTextField.text?.isEmpty)! && !(millilitreTextField.text?.isEmpty)! &&
            !(gallonTextField.text?.isEmpty)! && !(pintTextField.text?.isEmpty)! &&
            !(fluidOunceTextField.text?.isEmpty)! {
            return false
        }
        return true
    }
    

    func updateTextFields(textField: UITextField, unit: VolumeUnit) -> Void {
        if let input = textField.text {
            if input.isEmpty {
                clearTextFields()
            } else {
                if let value = Double(input as String) {
                let volume = Volume(unit: unit, value: value)
                
                for _unit in VolumeUnit.getAllUnits {
                    if _unit == unit {
                        continue
                    }
                    let textField = mapUnitToTextField(unit: _unit)
                    let result = volume.convert(unit: _unit)
                    
                    //rounding off to 4 decimal places
                    let roundedResult = Double(round(10000 * result) / 10000)
                    
                    textField.text = String(roundedResult)
                }
                }
            }
        }
    }
    
    func mapUnitToTextField(unit: VolumeUnit) -> UITextField {
        var textField = litreTextField
        switch unit {
        case .litre:
            textField = litreTextField
        case .millilitre:
            textField = millilitreTextField
        case .gallon:
            textField = gallonTextField
        case .pint:
            textField = pintTextField
        case .fluidOunce:
            textField = fluidOunceTextField
        }
        return textField!
    }
    
    func clearTextFields() {
        litreTextField.text = ""
        millilitreTextField.text = ""
        gallonTextField.text = ""
        pintTextField.text = ""
        fluidOunceTextField.text = ""
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
