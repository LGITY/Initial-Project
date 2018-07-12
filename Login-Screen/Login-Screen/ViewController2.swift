//
//  ViewController2.swift
//  Login-Screen
//
//  Created by Brad Levin on 7/7/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import Foundation
import UIKit
import Firebase




class ViewController2:
UIViewController {
    

    @IBOutlet weak var signinSelector: UISegmentedControl!
    @IBOutlet weak var signinLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var error_message: UITextField!
    
    
    
    var isSignIn:Bool = true
    //Boolean to check which part of the segmented control we are at
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //method needed to be done to allow Fibrebase API

        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        error_message.isHidden = true
        
        //Change the labels based n whether we're signing in or registering
        if isSignIn {
            print("signIn")
            self.signinLabel?.text = "Sign In"
            self.signinButton?.setTitle( "Sign In", for: .normal)
        }
        else {
            print("register")
            // if the signIn portion isn't toggled everything should say register
            signinLabel?.text = "Register"
            signinButton?.setTitle("Register", for: .normal)
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            
        }
    

    @IBAction func signinSelectorTapped(_ sender: Any) {
        
        print("suckadick")
        
        //Switch it when the button is tapped
        isSignIn = !isSignIn
        viewDidLoad()
        
        // Change the Sign in label and and button accordingly
       
    }
    let error_dict = ["The email address is badly formatted." : "Invalid Email", "There is no user record corresponding to this identifier. The user may have been deleted." : "Wrong email or password", "The email address is already in use by another account.": "Email is already being used", "The password must be 6 characters long or more.": "Password must be 6 characters or more", "The password is invalid or the user does not have a password." : "Invalid Password"]

    @IBAction func signInTapped(_ sender: UIButton) {
        print("herenow")
        //check if the text fields aren't empty
        if let email = emailTextField.text, let pass = passwordTextField.text {
            
            
            if isSignIn{
                print("sdafjl")
                
                // sign into existing user on firebase
                //if it works it makes user, if not it makes error
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    //makes sure the user isnt nill
                    
                    if user != nil {
                        //found a user, go to the home screen
                        self.error_message.isHidden = true
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        print("hello")
                    }
                    else {
                        self.error_message.isHidden = false
                        self.error_message.text = self.error_dict[(error?.localizedDescription)!]
                        print(error.debugDescription)
                        print("goodbye")
                        //check error and show message
                    }
                }
                )
                
            }
                
                
            else {
                
                // create a new user on firebase
                
                print(email)
                print(pass)
                //make a new user using email and store it as user, if it fails make error
                Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                    // ...
                    if user != nil {
                        //user is found go to home screen
                        print("heee")
                       
                        //go to next screen
                    self.error_message.isHidden = true
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else {
                        self.error_message.isHidden = false
                        self.error_message.text = self.error_dict[(error?.localizedDescription)!]
                        print(error.debugDescription)
                        // Error: check error and show message
                    }
                }
                
            }
            
        }
        
    }
    
        
    }

extension ViewController2:
UITextFieldDelegate {
    func textFieldShouldReturn(_ textField:
        UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}






