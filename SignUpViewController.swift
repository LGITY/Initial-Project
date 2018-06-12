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
        firstNameField.delegate = self as! UITextFieldDelegate
        lastNameField.delegate = self as! UITextFieldDelegate
        ageField.delegate = self as! UITextFieldDelegate
        emailField.delegate = self as! UITextFieldDelegate
        usernameField.delegate = self as! UITextFieldDelegate
        passwordField.delegate = self as! UITextFieldDelegate
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
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ageField.resignFirstResponder()
        
    }
}

extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
