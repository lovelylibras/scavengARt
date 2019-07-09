//
//  homeAlert.swift
//  scavengARt
//
//  Created by Rachel on 7/8/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit
import Foundation

class HomeAlert {
    func alert(message: String, completion: @escaping ((Bool) -> Void)) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "I'm sure", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: "Go back", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            completion(false)
        }))
        
        
      
        
        return alert
    }
}

