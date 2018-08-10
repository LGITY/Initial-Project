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

struct Store {
    var email: String
    var username: String
    var password: String
}

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
    @IBOutlet weak var dotFourth: UIView!
    @IBOutlet weak var dotLast: UIView!
    
    let bundleIdentifier =  Bundle.main.bundleIdentifier
    
    
    //next button outlet
    @IBOutlet weak var nextButton: UIButton!
    
    //Firebase database reference
    var ref: DatabaseReference!
    
    //array of users already created
    var userArray = [String]()
    var emailArray = [String]()

    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? SignUp2 {
            for (key, value) in info {
                destinationController.info[key] = value
            }
        }
            
        }
    
    override func viewDidLoad() {
        print("bundle: ", bundleIdentifier)
        emailTextView.delegate = self
        usernameTextView.delegate = self
        passwordTextView.delegate = self
        confirmPasswordTextView.delegate = self
        super.viewDidLoad()
//        print(userArray)
        
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
                let achild = bchild.value as? [String: String]
                var username = achild?["username"] as? String
                if let usr = username {
                    self.userArray.append(usr)
                }
//                print("userArray count: ", self.userArray.count)
            }
        })


    }
    
    func loadDots() {
        
        //add green dot
        dotFirst.backgroundColor = UIColor(red:0.03, green:1, blue:0.52, alpha:1)
        dotFirst.layer.cornerRadius = dotFirst.frame.size.width/2
        
        //adds grey dots
        let dotArray = [dotSecond, dotThird, dotFourth, dotLast] as! [UIView]
        for dot in dotArray {
            dot.backgroundColor = UIColor.lightGray
            dot.layer.cornerRadius = dot.frame.size.width/2
        }
    }
    
    func loadBackground() {
        //BACKGROUND
        //Sets up the background layer; creates a background rectangle, shades it in, and then adds the image in the background to fill the whole thing
        //let layer = UIView(frame: CGRect(x: -967, y: -214, width: 2337, height: 1547))
        backgroundColor.backgroundColor = UIColor(red:0.03, green:0.12, blue:0.18, alpha:0.8)
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
        
        //allows the textView to know everytime it is edited even by one letter. Calls the method textFieldDidChange every time edited
        textView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPos(textField: UITextField) -> Double{
        let screenHeight = UIScreen.main.bounds.height
        let globalPoint = textField.superview?.convert(textField.frame.origin, to: nil)
        let pos = Int((globalPoint?.y)!)
        let sorted_pos = Double(pos)/5.5
        return sorted_pos
        
    }
    lazy var email_pos: Double = getPos(textField: emailTextView)
    lazy var user_pos: Double = getPos(textField: usernameTextView)
    lazy var pass_pos: Double = getPos(textField: passwordTextView)
    lazy var confirm_pos: Double = getPos(textField: confirmPasswordTextView)
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        //checks to see if the text field is for the email
        if textField == emailTextView {
            do {
                //defines a regular expression that should match a valid email
                let regex =  try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                
                //if there are matches to the above regular expression, change the image to blue
                if regex.matches(in: emailTextView.text!, range: NSRange(emailTextView.text!.startIndex..., in: emailTextView.text!)).count > 0 && !emailArray.contains(emailTextView.text!) {
                    emailImage.image = #imageLiteral(resourceName: "MailIconBlueTrans")
                }
                    
                // if not, change the image to grey
                else {
                    emailImage.image = #imageLiteral(resourceName: "envelopeNew")
                }
            }
                
            // deal with potential error
            catch let error {
                print(error)
                return
            }
        }
        
        if textField == usernameTextView {
            if usernameTextView.text!.count > 0 && !userArray.contains(usernameTextView.text!) {
                usernameImage.image = #imageLiteral(resourceName: "PersonBlueTrans")
            }
            else {
                usernameImage.image = #imageLiteral(resourceName: "man")
            }
        }
        
        if textField == passwordTextView {
            if passwordTextView.text!.count > 5 {
                passwordImage.image = #imageLiteral(resourceName: "LockIconBlueTrans")
            }
            else {
                passwordImage.image = #imageLiteral(resourceName: "locked (1)")
            }
        }
        
        if textField == confirmPasswordTextView {
            if confirmPasswordTextView.text!.count > 5 {
                confirmPasswordImage.image = #imageLiteral(resourceName: "CheckCircleBlueTrans")
            }
            else {
                confirmPasswordImage.image = #imageLiteral(resourceName: "verified")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var sorted_pos = 0
        if textField == emailTextView {
            sorted_pos = Int(email_pos)
        }
        else if textField == usernameTextView {
            sorted_pos = Int(user_pos)
        }
        else if textField == passwordTextView {
            sorted_pos = Int(pass_pos)
        }
        else {
            sorted_pos = Int(confirm_pos)
        }

        moveTextField(textField: textField, moveDistance: sorted_pos, up: true)
    }
    
    //    func CFDictionaryGetValue(_: CFDictionary!, _: UnsafeRawPointer!) -> UnsafeRawPointer!
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var sorted_pos = 0
        if textField == emailTextView {
            sorted_pos = Int(email_pos)
        }
        else if textField == usernameTextView {
            sorted_pos = Int(user_pos)
        }
        else if textField == passwordTextView {
            sorted_pos = Int(pass_pos)
        }
        else {
            sorted_pos = Int(confirm_pos)
        }
        
        moveTextField(textField: textField, moveDistance: sorted_pos, up: false)
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
        UIView.commitAnimations()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getInfo() -> NSMutableDictionary {
        return info
    }
    
    //terms of service button
    @IBAction func termsButton(_ sender: Any) {
        print (info)
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
     var info: NSMutableDictionary  = ["email": "", "username" : "", "password": ""]
    
    @IBAction func nextPressed(_ sender: Any) {
        var userCreated = false
        if let email = emailTextView.text, let pass = passwordTextView.text, let user = usernameTextView.text, let confirm = confirmPasswordTextView.text {
            if email != ""{
                if user != "" {
                    if pass != "" {
                        
                    
                
                
            
            if pass == confirm {
//                print(termsPressed)
                if termsPressed {
                    //checks if username is available or not
                    if user.range(of: " ") == nil {
//                        print(userArray.count)
                        if !userArray.contains(self.usernameTextView.text!) {
                            info["email"] = email
                            info["username"] = user
                            info["password"] = pass
                            self.performSegue(withIdentifier: "toSignUp2", sender: self)
                            
                            
//                        Auth.auth().createUser(withEmail: email, password: pass, completion: {(user, error) in
//                            if user != nil {
//                                //makes user on authentication tab on firebase
//                                print("madeUser")
//                                self.performSegue(withIdentifier: "signIn2", sender: self)
//
//                                //creates the user with the username specified in the database
//                                let valArray =  ["username" : self.usernameTextView.text,"email" : self.emailTextView.text] as! [String: String]
//                                self.ref?.child("Users").child((user?.user.uid)!).setValue(valArray)
//                                userCreated = true
//                            }
//                            else {
//                                print("not ok")
//                                self.errorMessage = self.error_dict[(error?.localizedDescription)!]!
//                                self.errorLabel.isHidden = false
//                                self.reloadInputViews()
//                            }
//                        })
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
                    else {
                        self.errorMessage = "Invalid Email"
                    }
                }
                else {
                    self.errorMessage = "Invalid Username"
                }
            }
            else {
                self.errorMessage = "Inalid Password"
            }
        }
        errorLabel.text = self.errorMessage
        if !userCreated {
//            print(self.errorMessage)
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
