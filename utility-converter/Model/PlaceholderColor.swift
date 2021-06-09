//
//  UITextField+PlaceholderColor.swift
//  UtilityConvertor
//
//  Created by Vinojini Paramasivam on 21/3/8.
//eated by Brion Silva on 26/03/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//
import UIKit

extension UITextField {

    func _lightPlaceholderColor(_ color: UIColor) {
        var placeholderText = ""
        if self.placeholder != nil{
            placeholderText = self.placeholder!
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}
