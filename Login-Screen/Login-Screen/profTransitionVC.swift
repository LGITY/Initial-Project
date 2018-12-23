//
//  profTransitionVC.swift
//  Login-Screen
//
//  Created by Clayton Hebert on 12/23/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import Foundation
import UIKit



class profTransitionVC: UIViewController {
    
    var currentUser: String!
    
    var pastUsers: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
       // self.navigationItem.leftBarButtonItem = nil
        self.performSegue(withIdentifier: "backToProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? profile{
            destinationViewController.currentUser = currentUser
            destinationViewController.pastUsers = pastUsers
        }
    }
    
}
