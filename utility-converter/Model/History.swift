//
//  History.swift
//  UtilityConvertor
//
//  Created by Vinojini Paramasivam on 21/3/8.
//

import UIKit

class History {
    let type: String
    let icon: UIImage
    let conversion: String
    
    init(type: String, icon: UIImage, conversion: String) {
        self.type = type
        self.icon = icon
        self.conversion = conversion
    }
    
    func getHistoryType() -> String {
        return type
    }
    
    func getHistoryIcon() -> UIImage {
        return icon
    }
    
    func getHistoryConversion() -> String {
        return conversion
    }
}
