//
//  NewUserViewController.swift
//  scavengARt
//
//  Created by Rachel on 7/8/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {
  
    // OUTLETS FOR UI ELEMENTS
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var nameValidate: UILabel!
    @IBOutlet weak var userNameValidate: UILabel!
    @IBOutlet weak var passwordValidate: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // INITIALIZES USER TYPE
    var user:String = ""
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("user at viewDidLoad", user)
        
        userNameValidate.isHidden = true
        passwordValidate.isHidden = true
        nameValidate.isHidden = true
        
        // Sets conditional for user types – teacher or student
        if(user == "teacher") {
            emailLabel.text = "Email:"
            userNameText.placeholder = "Enter Email"
        } else {
            emailLabel.text = "Username:"
            userNameText.placeholder = "Enter Username"
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // VALIDATES USERS
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"Self MATCHES %@", emailRegEx)
        return emailTest.evaluate(with:email)
    }
    
    // HANDLES SIGN UP & VALIDATES INPUT
    @IBAction func didTapSignUpButton(_ sender: Any) {
        nameValidate.isHidden = true
        userNameValidate.isHidden = true
        passwordValidate.isHidden = true
        
        guard let name = nameText.text, nameText.text?.count != 0 else {
            nameValidate.isHidden = false
            nameValidate.text = "Please enter your name"
            return
        }
        
        guard let userName = userNameText.text, userNameText.text?.count != 0 else {
            userNameValidate.isHidden = false
            userNameValidate.text = user == "teacher" ? "Please enter your email" : "Please enter your username"
            return
        }
        
        if(user == "teacher" && isValidEmail(email: userName) == false) {
            userNameValidate.isHidden = false
            userNameValidate.text = "Please enter valid email address"
        }
        guard let password = passwordText.text, passwordText.text?.count != 0 else {
            passwordValidate.isHidden = false
            passwordValidate.text = "Please enter your password"
            return
        }
        
        let parameters = ["name":name,
                          "userName":userName,
                          "password":password]
        
        // POST REQUEST FOR NEW USER
        networkingService.request(endpoint: user == "teacher" ? "api/teachers" : "api/students", parameters: parameters) { (result) in
            
            switch result {
            case .success(let user): self.performSegue(withIdentifier: "newUserSegue", sender: user)
            case .failure(let error):
                let alert = self.alertService.alert(message: error.localizedDescription)
                self.present(alert, animated: true)
            }
        }
    }
    
    // SEGUE TO HOME ONCE USER IS SIGNED UP
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dashboardVC = segue.destination as? DashboardViewController, let user = sender as? User {
            dashboardVC.user = user
        }
    }
}
