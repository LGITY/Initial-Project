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
    usernameField.delegate = self as! UITextFieldDelegate
    passwordField.delegate = self as! UITextFieldDelegate
    }
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!


    @IBAction func LogInTapped(_ sender: Any) {
        var infoDict = ["Username": usernameField.text!, "Password": passwordField.text!]
    }
    
}


extension LogInViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
