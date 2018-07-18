//
//  SignUp1.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/16/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class SignUp1: UIViewController {
    var termsPressed = false
    
    //background and header outlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundColor: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var signUpLabel: UILabel!
    
    //email address outlets
    @IBOutlet weak var emailAddressBox: UIView!
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var emailImage: UIImageView!
    
    //username outlets
    @IBOutlet weak var usernameBox: UIView!
    @IBOutlet weak var usernameTextView: UITextField!
    @IBOutlet weak var usernameImage: UIImageView!
    
    //password outlets
    @IBOutlet weak var passwordBox: UIView!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var passwordImage: UIImageView!
    
    //confirm password outlets
    @IBOutlet weak var confirmPasswordBox: UIView!
    @IBOutlet weak var confirmPasswordTextView: UITextField!
    @IBOutlet weak var confirmPasswordImage: UIImageView!
    
    //terms of service verification outlets & the confirming variable for the check box
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var termsOuterStack: UIStackView!
    @IBOutlet weak var termsInnerStack: UIStackView!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var viewTermsButton: UIButton!
    let checkImage = #imageLiteral(resourceName: "unchecked")
    
    //status dot outlets and dot stack outlet
    @IBOutlet weak var dotStack: UIStackView!
    @IBOutlet weak var dotFirst: UIView!
    @IBOutlet weak var dotSecond: UIView!
    @IBOutlet weak var dotThird: UIView!
    @IBOutlet weak var dotLast: UIView!
    
    
    //next button outlet
    @IBOutlet weak var nextButton: UIButton!
    
    //Firebase database reference
    var ref: DatabaseReference!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //method needed to be done to allow Fibrebase API
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextView.resignFirstResponder()
        usernameTextView.resignFirstResponder()
        passwordTextView.resignFirstResponder()
        confirmPasswordTextView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        termsPressed = false
        //LOADS BACKGROUND
        loadBackground()
        
        //loads logo
        logo.image = #imageLiteral(resourceName: "plusonelogofulltrans")
        logo.contentMode = .scaleAspectFit
        
        //load login label
        signUpLabel.text = "Sign Up"
        signUpLabel.textAlignment = .center
        signUpLabel.textColor = UIColor.white
        
        //load email address creation
        loadTextView(emailTextView, box: emailAddressBox, im: emailImage)
        emailImage.image = #imageLiteral(resourceName: "envelopeNew")
        emailTextView.attributedPlaceholder = NSAttributedString(string: "email address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        //load username creation
        loadTextView(usernameTextView, box: usernameBox, im: usernameImage)
        usernameImage.image = #imageLiteral(resourceName: "man")
        usernameTextView.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        //load password creation
        loadTextView(passwordTextView, box: passwordBox, im: passwordImage)
        passwordImage.image = #imageLiteral(resourceName: "locked (1)")
        passwordTextView.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        //load confirm password
        loadTextView(confirmPasswordTextView, box: confirmPasswordBox, im: confirmPasswordImage)
        confirmPasswordImage.image = #imageLiteral(resourceName: "verified")
        confirmPasswordTextView.attributedPlaceholder = NSAttributedString(string: "confirm password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        //load next button
        nextButton.layer.cornerRadius = 15
        
        //load dots
        loadDots()
        
    }
    
    func loadDots() {
        
        //add green dot
        dotFirst.backgroundColor = UIColor(red:0.03, green:1, blue:0.52, alpha:1)
        dotFirst.layer.cornerRadius = dotFirst.frame.size.width/2
        
        //adds grey dots
        let dotArray = [dotSecond, dotThird, dotLast] as! [UIView]
        for dot in dotArray {
            dot.backgroundColor = UIColor.lightGray
            dot.layer.cornerRadius = dot.frame.size.width/2
        }
    }
    
    func loadBackground() {
        //BACKGROUND
        //Sets up the background layer; creates a background rectangle, shades it in, and then adds the image in the background to fill the whole thing
        //let layer = UIView(frame: CGRect(x: -967, y: -214, width: 2337, height: 1547))
        backgroundColor.backgroundColor = UIColor(red:0.03, green:0.12, blue:0.18, alpha:0.7)
        //self.view.addSubview(layer)
        backgroundImage.image = #imageLiteral(resourceName: "sign-up-background")
        backgroundImage.contentMode = .scaleAspectFill
    }
    
    func loadTextView(_ textView: UITextField, box: UIView, im: UIImageView) {
        //loads the surrounding box for the username
        box.backgroundColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1)
        box.layer.borderWidth = 2
        box.layer.borderColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1).cgColor
        box.layer.cornerRadius = 15
        box.layer.masksToBounds = true
        
        //loads the mail logo next to the username
        im.contentMode = .scaleAspectFit
        
        //loads the textfield for the username
        textView.backgroundColor = UIColor.clear
        textView.borderStyle = .none
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //terms of service button
    @IBAction func termsButton(_ sender: Any) {
        if termsPressed {
            termsPressed = false
        }
        else {
            termsPressed = true
        }
        
        if termsButton.currentImage == checkImage {
            termsButton.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
        else {
            termsButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let error_dict = ["The email address is badly formatted." : "Invalid email address", "There is no user record corresponding to this identifier. The user may have been deleted." : "Incorrect email or password", "The email address is already in use by another account.": "Email address already taken", "The password must be 6 characters long or more.": "Password must be at least 6 characters", "The password is invalid or the user does not have a password." : "Invalid password", "The Internet connection appears to be offline." : "Could not connect to Internet"]
    
    var errorMessage = ""
    @IBAction func nextPressed(_ sender: Any) {
        
        //reference implementation for Firebase Database
        ref = Database.database().reference()
        
        
        if let email = emailTextView.text, let pass = passwordTextView.text, let user = usernameTextView.text, let confirm = confirmPasswordTextView.text {
            if pass == confirm {
                print(termsPressed)
                if termsPressed {
                    
                    if user.range(of: " ") == nil {
                    
                
                Auth.auth().createUser(withEmail: email, password: pass, completion: {(user, error) in
                    if user != nil {
                        print("madeUser")
                        self.performSegue(withIdentifier: "signIn2", sender: self)
                        
                        //creates user in database, stores username
                        let valArray = ["username" : self.usernameTextView.text] as! [String: String]
                        self.ref?.child("Users").child((user?.user.uid)!).setValue(valArray)

                    }
                    
                    else {
                        print("not ok")
                        
                        self.errorMessage = self.error_dict[(error?.localizedDescription)!]!
                        print(self.errorMessage)
                    }
                    }

                    
                
                )
                        

                }
                    else {
                        self.errorMessage = "Invalid Username"
                        print(errorMessage)
                    }

                }

                }

                
            }
        
            
            
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



extension SignUp1:
UITextFieldDelegate {
    func textFieldShouldReturn(_ textField:
        UITextField) -> Bool {
        emailTextView.resignFirstResponder()
        usernameTextView.resignFirstResponder()
        passwordTextView.resignFirstResponder()
        confirmPasswordTextView.resignFirstResponder()
        return true
    }
}
