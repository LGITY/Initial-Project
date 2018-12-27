//
//  LoginFormatted.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/13/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


class LoginFormatted: UIViewController {
    
    
    //background and logo outlets
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var backgroundColor: UIView!
    
    //login label outlet
    @IBOutlet weak var loginLabel: UILabel!
    
    //username outlets
    @IBOutlet weak var usernameBox: UIView!
    @IBOutlet weak var usernameImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    //password outlets
    @IBOutlet weak var passwordBox: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordImage: UIImageView!
    
    //Login error outlet
    @IBOutlet weak var loginError: UILabel!
    
    
    //facebook outlets
    @IBOutlet weak var facebookBox: UIView!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var facebookButton: UIButton!
    
    
    //log in button outlet
    @IBOutlet weak var loginButton: UIButton!
    
    //forgot p, pp, sign up, and tos outlets
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var privacyPolicy: UIButton!
    @IBOutlet weak var termsOfService: UIButton!
    @IBOutlet weak var signUpStackView: UIStackView!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //method needed to be done to allow Fibrebase API
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }
    
    
    override func viewDidLoad() {
        print("dklkklkl")
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        super.viewDidLoad()
        
        //LOADS BACKGROUND
        loadBackground()
        
        //load logo
        logo.image = #imageLiteral(resourceName: "plusonelogofulltrans")
        logo.contentMode = .scaleAspectFit
        
        //load login label
        loginLabel.text = "Log in"
        loginLabel.textAlignment = .center
        loginLabel.textColor = UIColor.white
        
        //load username
        loadTextView(usernameTextField, box: usernameBox, im: usernameImage)
        usernameImage.image = #imageLiteral(resourceName: "envelopeNew")
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "email address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        //load password
        loadTextView(passwordTextField, box: passwordBox, im: passwordImage)
        passwordImage.image = #imageLiteral(resourceName: "locked (1)")
        passwordImage.contentMode = .scaleAspectFit
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        //load login button
        loginButton.layer.cornerRadius = 15
        
        //load facebook
        //loads the surrounding box for facebook
        facebookBox.backgroundColor = UIColor(red:0.23, green:0.35, blue:0.6, alpha:1)
        facebookBox.layer.borderWidth = 2
        facebookBox.layer.borderColor = UIColor(red:0.23, green:0.35, blue:0.6, alpha:1).cgColor
        facebookBox.layer.cornerRadius = 15
        facebookBox.layer.masksToBounds = true
        //loads the facebook logo next to the button
        facebookImage.contentMode = .scaleAspectFit
        facebookImage.image = #imageLiteral(resourceName: "facebookNew")
        
        //Hides error text
        loginError.text = ""
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
    
    func loadBackground() {
        //BACKGROUND
        //Sets up the background layer; creates a background rectangle, shades it in, and then adds the image in the background to fill the whole thing
        //let layer = UIView(frame: CGRect(x: -967, y: -214, width: 2337, height: 1547))
        backgroundColor.backgroundColor = UIColor(red:0.03, green:0.12, blue:0.18, alpha:0.8)
        //self.view.addSubview(layer)
        background.image = #imageLiteral(resourceName: "login")
        background.contentMode = .scaleAspectFill
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
//    func CFDictionaryGetValue(_: CFDictionary!, _: UnsafeRawPointer!) -> UnsafeRawPointer!
    
    func getPos(textField: UITextField) -> Double{
        let screenHeight = UIScreen.main.bounds.height
        let globalPoint = textField.superview?.convert(textField.frame.origin, to: nil)
        let pos = Int((globalPoint?.y)!)
        let sorted_pos = Double(pos)/4.5
        return sorted_pos
        
    }
    lazy var user_pos: Double = getPos(textField: usernameTextField)
    lazy var pass_pos: Double = getPos(textField: passwordTextField)
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("user_pos: ", user_pos)
        print("pass_pos: ", pass_pos)
        var sorted_pos = 0
        if textField == usernameTextField {
            print("user")
            sorted_pos = Int(user_pos)
        }
            
        else {
            print("pass")
            sorted_pos = Int(pass_pos)
        }
        moveTextField(textField: textField, moveDistance: sorted_pos, up: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        var sorted_pos = 0
        if textField == usernameTextField {
            print("user")
            sorted_pos = Int(user_pos)
        }
            
        else {
            print("pass")
            sorted_pos = Int(pass_pos)
        }
        moveTextField(textField: textField, moveDistance: Int(sorted_pos), up: false)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //checks to see if the text field is for the email
        if textField == passwordTextField {
            if passwordTextField.text!.count > 5 {
                passwordImage.image = #imageLiteral(resourceName: "LockIconBlueTrans")
            }
            else {
                passwordImage.image = #imageLiteral(resourceName: "locked (1)")
            }
        }
        
        if textField == usernameTextField {
            do {
                //defines a regular expression that should match a valid email
                let regex =  try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                
                //if there are matches to the above regular expression, change the image to blue
                if regex.matches(in: usernameTextField.text!, range: NSRange(usernameTextField.text!.startIndex..., in: usernameTextField.text!)).count > 0 {
                    usernameImage.image = #imageLiteral(resourceName: "MailIconBlueTrans")
                }
                // if not, change the image to grey
                else {
                    usernameImage.image = #imageLiteral(resourceName: "envelopeNew")
                }
            }
            // deal with potential error
            catch let error {
                print(error)
                return
            }
        }
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    let error_dict = ["The email address is badly formatted." : "Invalid Email", "There is no user record corresponding to this identifier. The user may have been deleted." : "Wrong email or password", "The email address is already in use by another account.": "Email is already being used", "The password must be 6 characters long or more.": "Password must be 6 characters or more", "The password is invalid or the user does not have a password." : "Invalid Password", "The Internet connection appears to be offline." : "Check Internet Connection"]
    @IBAction func logInTapped(_ sender: Any) {
        if let email = usernameTextField.text, let pass = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: pass, completion: {(user, error) in
                if user != nil {
                    print("ok")
                    
                    //sets up the global variable for the current user
                    SignUp1.User.uid = (user?.user.uid)!
                    print(SignUp1.User.uid)
                    print("THIS WAS THE STORED ID ^")
                    self.performSegue(withIdentifier: "goHome", sender: self)
                    // in the future we will use self.performSegue() to have it move to the next screen
                }
                else {
                    print("not ok")
                    let errorMessage = self.error_dict[(error?.localizedDescription)!]
                    self.loginError.text = errorMessage
                }
                
            }
            )
        }
    }
    
    @IBAction func facebookPressed(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            //dkddkkd
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                // Present the main view
                //Might want to take this code out
                //Possible sigAbort
//                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
//                    UIApplication.shared.keyWindow?.rootViewController = viewController
//                    self.dismiss(animated: true, completion: nil)
//            }
                
                
            })
            
        }
    }
    
}

extension LoginFormatted:
UITextFieldDelegate {
    func textFieldShouldReturn(_ textField:
        UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
