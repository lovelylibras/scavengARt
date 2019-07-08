//
//  AlertService.swift
//  scavengARt
//
//  Created by Rachel on 7/7/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//
import UIKit
import Foundation

class AlertService {
    func alert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        return alert
    }
}
