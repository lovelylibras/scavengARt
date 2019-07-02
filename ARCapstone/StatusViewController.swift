//
//  StatusViewController.swift
//  scavengARt
//
//  Created by Ahsun on 7/2/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

class StatusViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Visited Paintings"
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var tableViewVisited: UITableView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
