//
//  LogInViewController.swift
//  Plus One
//
//  Created by Brad Levin on 6/12/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import Foundation
import UIKit

class LogInViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    usernameField.delegate = self
    passwordField.delegate = self
    logIn.isEnabled = false
    }
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logIn: UIButton!
    

    func checkFields () -> Bool {
        
        
        let varList = [usernameField, passwordField]
        for field in varList {
            if field?.text! == "" {
                print("sup chach")
                return false
            }
        }
        return true
    }
    
    func setSignUp () {
        
        if checkFields() == false {
            
            logIn.isEnabled = false
        }
        else {
            logIn.isEnabled = true
        }
    }

    @IBAction func LogInTapped(_ sender: Any) {
        let infoDict = ["Username": usernameField.text!, "Password": passwordField.text!]
    }
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            usernameField.resignFirstResponder()
            passwordField.resignFirstResponder()
            setSignUp()
    }
}


extension LogInViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        setSignUp()
        return true
    }
}
