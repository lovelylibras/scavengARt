//
//  EntryViewController.swift
//  scavengARt
//
//  Created by Rachel on 7/7/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit



class EntryViewController: UIViewController {

    @IBAction func teacherSelect(_ sender: UIButton) {
    }
    @IBAction func studentSelect(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard let loginVC = segue.destination as? LoginViewController else {return}
        if segue.identifier == "teacher" {
            loginVC.user = "teacher"
        }else if segue.identifier == "student" {
           loginVC.user = "student"
        }
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
