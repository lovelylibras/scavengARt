//
//  DashboardViewController.swift
//  scavengARt
//
//  Created by Rachel on 7/8/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    var user = User(id: 0, name: "", userName: "")
    @IBOutlet weak var welcomeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeText.text = "Welcome, \(user.name)"
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
