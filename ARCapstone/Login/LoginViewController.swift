//
//  LoginViewController.swift
//  scavengARt
//
//  Created by Rachel on 7/7/19.
//  Copyright © 2019 Audra Kenney. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    // OUTLETS FOR UI ELEMENTS
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameValidate: UILabel!
    @IBOutlet weak var passwordValidate: UILabel!
    
    // INITIALIZES USER TYPE
    var user:String = ""

    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("user at viewDidLoad", user)
        
        userNameValidate.isHidden = true
        passwordValidate.isHidden = true
        
        // Sets conditional for user types – teacher or student
        if(user == "teacher") {
            userNameTextField.placeholder = "Enter Email"
        } else {
            userNameTextField.placeholder = "Enter Username"
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // VALIDATES USERS
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"Self MATCHES %@", emailRegEx)
        return emailTest.evaluate(with:email)
    }

    // HANDLES LOG IN & VALIDATES INPUT
    @IBAction func didTapLoginBtn(_ sender: Any) {
        userNameValidate.isHidden = true
        passwordValidate.isHidden = true
        
        guard let userName = userNameTextField.text, userNameTextField.text?.count != 0 else {
            userNameValidate.isHidden = false
            userNameValidate.text = user == "teacher" ? "Please enter your email" : "Please enter your username"
            return
        }
        
        if(user == "teacher" && isValidEmail(email: userName) == false) {
            userNameValidate.isHidden = false
            userNameValidate.text = "Please enter valid email address"
        }
        guard let password = passwordTextField.text, passwordTextField.text?.count != 0 else {
            passwordValidate.isHidden = false
            passwordValidate.text = "Please enter your password"
            return
        }
        
        let parameters = ["userName":userName,
                          "password":password]
        
        // GET REQUEST FOR EXISTING USER
        networkingService.request(endpoint: user == "teacher" ? "auth/teacher-login" : "auth/student-login", parameters: parameters) { (result) in
            switch result {
            case .success(let user): self.performSegue(withIdentifier: "loginSegue", sender: user)
            case .failure(let error):
                 let alert = self.alertService.alert(message: error.localizedDescription)
                self.present(alert, animated: true)
            }
        }
    }
    
    // SEGUE TO HOME ONCE USER IS LOGGED IN
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newUserVC = segue.destination as? NewUserViewController {
            newUserVC.user = self.user
        }
        if let dashboardVC = segue.destination as? DashboardViewController, let user = sender as? User {
            dashboardVC.user = user
        }
    }
}
