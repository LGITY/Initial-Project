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
    
    //Error label outlet
    @IBOutlet weak var errorLabel: UILabel!
    
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
    
    //array of users already created
    var userArray = [String]()
    
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
        print("djklafkj")
        
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
        
        //load error message
        errorLabel.isHidden = true
        
        //reference implementation for Firebase Database
        ref = Database.database().reference()
        
        //imports already created usernames to userArray
        self.ref?.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let bchild = child as! DataSnapshot
                let achild = bchild.value as! [String: String]
                var username = achild["username"] as! String
                self.userArray.append(username)
            }
        })
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let globalPoint = textField.superview?.convert(textField.frame.origin, to: nil)
        print(globalPoint)
        moveTextField(textField: textField, moveDistance: 125, up: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let globalPoint = textField.superview?.convert(textField.frame.origin, to: nil)
        print(globalPoint)

        moveTextField(textField: textField, moveDistance: 125, up: false)
    }
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.2
        //this is an inline if statement that checks if up is true or not
        let movement : CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        //self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        //self.view.frame.origin.y += textField.frame.origin.y
        UIView.commitAnimations()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
            termsButton.setImage(#imageLiteral(resourceName: "CheckedBox copy2"), for: .normal)
        }
        else {
            termsButton.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        }
        termsButton.contentMode = .scaleAspectFit
    }
    
    let error_dict = ["The email address is badly formatted." : "Invalid email address", "There is no user record corresponding to this identifier. The user may have been deleted." : "Incorrect email or password", "The email address is already in use by another account.": "Email address already taken", "The password must be 6 characters long or more.": "Password must be at least 6 characters", "The password is invalid or the user does not have a password." : "Invalid password", "The Internet connection appears to be offline." : "Could not connect to Internet", "Username taken" : "Username already taken! Try another.", "Terms unpressed" : "Please accept the terms and conditions", "Passwords inconsistent" : "Passwords do not match"]
    
    var errorMessage = ""
    @IBAction func nextPressed(_ sender: Any) {
        var userCreated = false
        if let email = emailTextView.text, let pass = passwordTextView.text, let user = usernameTextView.text, let confirm = confirmPasswordTextView.text {
            if pass == confirm {
                print(termsPressed)
                if termsPressed {
                    //checks if username is available or not
                    if user.range(of: " ") == nil {
                        print(userArray.count)
                        if !userArray.contains(self.usernameTextView.text!) {
                        Auth.auth().createUser(withEmail: email, password: pass, completion: {(user, error) in
                            if user != nil {
                                //makes user on authentication tab on firebase
                                print("madeUser")
                                self.performSegue(withIdentifier: "signIn2", sender: self)
                                
                                //creates the user with the username specified in the database
                                let valArray = ["username" : self.usernameTextView.text] as! [String: String]
                                self.ref?.child("Users").child((user?.user.uid)!).setValue(valArray)
                                userCreated = true
                            }
                            else {
                                print("not ok")
                                self.errorMessage = self.error_dict[(error?.localizedDescription)!]!
                                self.errorLabel.isHidden = false
                                self.reloadInputViews()
                            }
                        })
                    }
                    else {
                        self.errorMessage = self.error_dict["Username taken"]!
                        }
                }
                else {
                    self.errorMessage = self.error_dict["Invalid Username"]!
                }
            }
                else {
                    self.errorMessage = self.error_dict["Terms unpressed"]!
                }
        }
            else {
                self.errorMessage = self.error_dict["Passwords inconsistent"]!
            }
        }
        errorLabel.text = self.errorMessage
        if !userCreated {
            print(self.errorMessage)
            errorLabel.isHidden = false
        }
        reloadInputViews()
        //self.reloadInputViews()
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