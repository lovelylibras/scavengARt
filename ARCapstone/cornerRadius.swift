//
//  cornerRadius.swift
//  scavengARt
//
//  Created by Rachel on 7/10/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

public extension UIView {
    
    /// Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        
        set (cornerRadious) {
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadious
        }
    }
    
}
