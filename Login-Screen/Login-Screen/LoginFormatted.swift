//
//  LoginFormatted.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/13/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class LoginFormatted: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var backgroundColor: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var usernameBox: UIView!
    @IBOutlet weak var usernameImage: UIImageView!
    
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
        // TODO: Make function for this
        usernameBox.backgroundColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1)
        usernameBox.layer.borderWidth = 12
        usernameBox.layer.borderColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1).cgColor
        usernameBox.layer.cornerRadius = 15
        usernameBox.layer.masksToBounds = true
        usernameImage.image = #imageLiteral(resourceName: "envelope")
        usernameImage.contentMode = .scaleAspectFit
    }
    
    func loadBackground() {
        //BACKGROUND
        //Sets up the background layer; creates a background rectangle, shades it in, and then adds the image in the background to fill the whole thing
        //let layer = UIView(frame: CGRect(x: -967, y: -214, width: 2337, height: 1547))
        backgroundColor.backgroundColor = UIColor(red:0.03, green:0.12, blue:0.18, alpha:0.5)
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
