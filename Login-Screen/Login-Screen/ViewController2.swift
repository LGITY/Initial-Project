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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            
        }
    
    @IBAction func signinSelectorChanged(_ sender: UISegmentedControl) {
        print("suckadick")
        
        //Switch it when the button is tapped
        isSignIn = !isSignIn
        
        // Change the Sign in label and and button accordingly
        if isSignIn {
            signinLabel.text = "Sign In"
            signinButton.setTitle( "Sign In", for: .normal)
        }
        else {
            // if the signIn portion isn't toggled everything should say register
            signinLabel.text = "Register"
            signinButton.setTitle("Register", for: .normal)
        }
        
        
        
    }
    @IBAction func sigininButtonTapped(_ sender: UIButton) {
        if let email = emailTextField?.text, let pass = passwordTextField?.text {
            if isSignIn{
                
                // sign into existing user on firebase
                Auth.auth().signIn(withEmail: email, link: pass, completion: { (user, error) in
                    //makes sure the user isnt nill
                    
                    if let u = user {
                        //found a user, go to the home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        print("hello")
                    }
                    else {
                        print("goodbye")
                        //check error and show message
                    }
                })
            
        }
            
        
        else {
            
            // create a new user on firebase
                
            
        Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
            
            //check that user isnt nil
            if let u = user {
                //user is found go to home screen
                print("heee")
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
            else {
                print("hooo")
                // Error: check error and show message
            }
            })
        }
}

    }}


