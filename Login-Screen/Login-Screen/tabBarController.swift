//
//  tabBarController.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/28/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class tabBarController: UITabBarController {

    var userInfo : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getting all the information about the user
        userInfo.updateInfo()
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
