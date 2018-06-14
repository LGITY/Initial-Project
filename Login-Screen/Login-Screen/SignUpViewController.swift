//
//  SignUpViewController.swift
//  Plus One
//
//  Created by Brad Levin on 6/12/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameField.delegate = self
        lastNameField.delegate = self
        ageField.delegate = self
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
    }

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signUpTapped(_ sender: Any) {
        var infoDict = ["First Name": firstNameField.text!, "Last Name": lastNameField.text!, "Age": ageField.text!, "Email": emailField.text!, "Username": usernameField.text!, "Password": passwordField.text!]
        print(infoDict)
        print(infoDict["Password"])
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        ageField.resignFirstResponder()
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
    }
}

extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
