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
    @IBOutlet weak var emailBox: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavigationBar()
        loadBackground()
        loadForgotPassword()
        loadMessage()

        // Do any additional setup after loading the view.
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
        message.textColor = UIColor.white
        
    }
    
    func loadEmailBox() {
        emailBox.alpha = 0.70
        emailBox.backgroundColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1)
        emailBox.layer.borderWidth = 12
        emailBox.layer.borderColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:0.7).cgColor
        self.view.addSubview(emailBox)
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
