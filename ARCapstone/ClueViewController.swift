//
//  ClueViewController.swift
//  scavengARt
//
//  Created by Rachel on 7/5/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

class ClueViewController: UIViewController {

    @IBOutlet weak var clueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.clueLabel.text = "Find \(clues[0].name)"
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
