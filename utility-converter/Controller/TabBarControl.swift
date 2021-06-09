//
//  TabBarController.swift
//  UtilityConvertor
//
//  Created by Vinojini Paramasivam on 21/3/8.
//

import UIKit

class TabBarControl: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is UINavigationController {
            print("Conversions tab")
        } else if viewController is SaveVC {
            print("Save tab")
        } else if viewController is HistoryVC {
            print("History tab")
        } else if viewController is SettingsVC {
            print("Constants tab")
        }
    }
}

