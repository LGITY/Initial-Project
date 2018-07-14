//
//  LoginFormatted.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/13/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
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
    
    func loadBackground() {
        //BACKGROUND
        //Sets up the background layer; creates a background rectangle, shades it in, and then adds the image in the background to fill the whole thing
        //let layer = UIView(frame: CGRect(x: -967, y: -214, width: 2337, height: 1547))
        backgroundColor.backgroundColor = UIColor(red:0.03, green:0.12, blue:0.18, alpha:0.7)
        //self.view.addSubview(layer)
        background.image = #imageLiteral(resourceName: "login")
        background.contentMode = .scaleAspectFill
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
