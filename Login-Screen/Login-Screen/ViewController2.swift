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
    
    
    
    var isSignIn:Bool = true
    //Boolean to check which part of the segmented control we are at
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //method needed to be done to allow Fibrebase API

        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        print("hello")
                    }
                    else {
                        
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
                    if let u = user {
                        //user is found go to home screen
                        print("heee")
                       
                        //go to next screen
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else {
                        print("hooo")
                        // Error: check error and show message
                    }
                }
                
            }
            
        }
        
    }
    
        
    }
    






