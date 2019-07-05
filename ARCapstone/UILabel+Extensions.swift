//
//  UILabel+Extensions.swift
//  scavengARt
//
//  Created by Ahsun on 7/5/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    
    func showText(_ text: String, andHideAfter delay: Double) {
        DispatchQueue.main.async {
            self.text = text
            self.alpha = 1
            UIView.animate(withDuration: delay, animations: {self.alpha = 0})
        }
    }
}
