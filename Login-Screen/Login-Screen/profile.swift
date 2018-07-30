//
//  profile.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/29/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class profile: UIViewController {
    
    //nav bar outlets
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    //profile background outlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var usrName: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var divider: UIView!
    
    //selector gadget
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var info: Dictionary<String, String> = [:]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loads navigation bar
        loadNavigationBar()
        
        //loads background pic for profile and shit
        loadProfBackground()
            
        let ref = Database.database().reference()
        
        //load profile picture image
        
        //TO DO: to figure out how to mke the user's easily accessible
        //profPic.image = ref.child("Users")
        profPic.contentMode = .scaleToFill
        profPic.layer.backgroundColor = UIColor.white.withAlphaComponent(0.40).cgColor
        profPic.layer.cornerRadius = profPic.frame.size.width/2
        profPic.clipsToBounds = true
        profPic.isHidden = false
        
        //load profile picture label
        usrName.text = "Aaron Slutkin"
        usrName.textAlignment = .center
        usrName.textColor = UIColor.white
        
        //sub-profile-picture label
        friendsLabel.textColor = UIColor.white
        eventsLabel.textColor = UIColor.white
        
        //load segmented control
        //segmentedControl.layer.backgroundColor = UIColor.clear.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    
    func loadProfBackground() {
        backgroundImage.image = #imageLiteral(resourceName: "login")
    }
    
    func loadNavigationBar() {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        
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
