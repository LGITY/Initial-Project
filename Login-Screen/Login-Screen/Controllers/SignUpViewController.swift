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
        signUp.isEnabled = false
        firstNameField.delegate = self
        lastNameField.delegate = self
        ageField.delegate = self
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
//        print(checkFields())
    }

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUp: UIButton!
    
    
    func checkFields () -> Bool {
        let varList = [firstNameField, lastNameField, ageField, emailField, usernameField, passwordField]
        for field in varList {
            if field?.text! == "" {
                print("sup chach")
                return false
                }
            }
            return true
        }
    
    func setSignUp () {
        signUp.isEnabled = checkFields()
    }


    
    @IBAction func signUpTapped(_ sender: Any) {
        

        let infoDict = ["First Name": firstNameField.text!, "Last Name": lastNameField.text!, "Age": ageField.text!, "Email": emailField.text!, "Username": usernameField.text!, "Password": passwordField.text!]
        print(infoDict)
        print("faaack")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        ageField.resignFirstResponder()
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        setSignUp()
        
    }
}

extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        setSignUp()
        return true
    }
}
