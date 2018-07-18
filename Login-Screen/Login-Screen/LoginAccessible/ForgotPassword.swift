//
//  ForgotPassword.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/16/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class ForgotPassword: UIViewController {
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var backgroundColor: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var message: UILabel!
    
    //email outlets
    @IBOutlet weak var emailBox: UIView!
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var emailImage: UIImageView!
    
    //send button outlet
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavigationBar()
        loadBackground()
        logo.image = #imageLiteral(resourceName: "plusOne")
        logo.contentMode = .scaleAspectFit
        loadForgotPassword()
        loadMessage()
        loadTextView(emailTextView, box: emailBox, im: emailImage)
        emailImage.image = #imageLiteral(resourceName: "envelopeNew")
        emailImage.contentMode = .scaleAspectFit
        emailTextView.attributedPlaceholder = NSAttributedString(string: "email address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        //load send button
        sendButton.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func send(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func loadBackground() {
//        let layer = UIView(frame: CGRect(x: -2, y: -2, width: 752, height: 1209))
        backgroundColor.backgroundColor = UIColor(red:0.03, green:0.12, blue:0.18, alpha:0.7)
//        layer.layer.borderWidth = 10
//        layer.layer.borderColor = UIColor.white.cgColor
//        self.view.addSubview(layer)
        background.image = #imageLiteral(resourceName: "remi-jacquaint-519310-unsplash")
        background.contentMode = .scaleAspectFill
    }
    
    func loadLogo() {
        logo.image = #imageLiteral(resourceName: "plusonelogofulltrans")
        logo.contentMode = .scaleAspectFit
    }
    
    
    func loadForgotPassword() {
        forgotPasswordLabel.text = "Forgot Password"
        forgotPasswordLabel.textAlignment = .center
        forgotPasswordLabel.textColor = UIColor.white
        forgotPasswordLabel.sizeToFit()
        forgotPasswordLabel.font = UIFont(name: "Futura-Bold", size: 32)
    }
    
    func loadMessage() {
        message.textAlignment = .center
        
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
    

    
    func loadNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
