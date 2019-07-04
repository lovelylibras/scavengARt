//
//  ClueViewController.swift
//  scavengARt
//
//  Created by Audra Kenney on 7/3/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

class ClueViewController: UIViewController {

    @IBOutlet weak var clue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clue.text = clues[0].name
    }
    
}
