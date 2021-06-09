//
//  CustomNumericKeyBoard.swift
//  UtilityConvertor
//
//  Created by Vinojini Paramasivam on 21/3/8.
//

import UIKit

let customNKbRecommendedHeight = 274.00

private let defaultKeyColour = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00)
private let pressedKeyColour = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.00)

@objc protocol CustomNumericKeyboardDelegate {
    func numericKeyPressed(key: Int)
    func numericBackspacePressed()
    func numericSymbolPressed(symbol: String)
    func retractKeyPressed()
}

class CustomNumericKeyboard: UIView {

    @IBOutlet weak var btnKey0: UIButton!
    @IBOutlet weak var btnKey1: UIButton!
    @IBOutlet weak var btnKey2: UIButton!
    @IBOutlet weak var btnKey3: UIButton!
    @IBOutlet weak var btnKey4: UIButton!
    @IBOutlet weak var btnKey5: UIButton!
    @IBOutlet weak var btnKey6: UIButton!
    @IBOutlet weak var btnKey7: UIButton!
    @IBOutlet weak var btnKey8: UIButton!
    @IBOutlet weak var btnKey9: UIButton!
    @IBOutlet weak var btnKeyMinus: UIButton!
    @IBOutlet weak var btnKeyPeriod: UIButton!
    @IBOutlet weak var btnKeyBackspace: UIButton!
    @IBOutlet weak var btnKeyRetract: UIButton!
    
    var allButtons: [UIButton] { return [btnKey0, btnKey1, btnKey2, btnKey3, btnKey4, btnKey5, btnKey6, btnKey7, btnKey8, btnKey9, btnKeyPeriod, btnKeyMinus] }
    
    
    weak var delegate: CustomNumericKeyboardDelegate?
    
    var btnDefaultBgColour = defaultKeyColour { didSet { updateButtonAppearance() } }
    var btnPressedBgColour = pressedKeyColour { didSet { updateButtonAppearance() } }
    var btnDefaultFontColor = UIColor.gray { didSet { updateButtonAppearance() } }
    var btnPressedFontColor = UIColor.white { didSet { updateButtonAppearance() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(enableMinusButton(notification:)),
                                               name: NSNotification.Name(rawValue: "enableMinusButton"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeKeyboard()
    }
    
    func initializeKeyboard() {
        let xibFileName = "CustomNumericKeyboard"
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        
        updateButtonAppearance()
        btnKeyMinus.isUserInteractionEnabled = false
    }
    
    fileprivate func updateButtonAppearance() {
        for button in allButtons {
            button.setTitleColor(btnDefaultFontColor, for: .normal)
            button.setTitleColor(btnPressedFontColor, for: [.selected, .highlighted])
            if button.isSelected {
                button.backgroundColor = btnPressedBgColour
            } else {
                button.backgroundColor = btnDefaultBgColour
            }
        }
    }
    
    @objc func enableMinusButton(notification: NSNotification) {
        btnKeyMinus.isUserInteractionEnabled = true
    }
    
    @IBAction func handleNumericButtonPress(_ sender: UIButton) {
        self.delegate?.numericKeyPressed(key: sender.tag)
    }
    @IBAction func handleBackspaceButtonPress(_ sender: AnyObject) {
        self.delegate?.numericBackspacePressed()
    }
    
    @IBAction func handleSymbolButtonPress(_ sender: UIButton) {
        if let symbol = sender.titleLabel?.text, symbol.count > 0 {
            self.delegate?.numericSymbolPressed(symbol: symbol)
        }
    }
    
    @IBAction func handleRetractButtonPress(_ sender: Any) {
        self.delegate?.retractKeyPressed()
    }
}

