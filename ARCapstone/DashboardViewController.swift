//
//  DashboardViewController.swift
//  scavengARt
//
//  Created by Rachel on 7/8/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // INITIALIZES USER
    var user = User(id: 0, name: "", userName: "")
    
    // OUTLET FOR UI ELEMENTS
    @IBOutlet weak var welcomeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set text for welcoming user
        welcomeText.text = "Welcome, \(user.name)"
    }
}
