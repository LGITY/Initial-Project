//
//  profileTransition.swift
//  Login-Screen
//
//  Created by Davis Booth on 9/7/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class profileTransition: UIViewController {

    
    var changeUser: String?
    var pastUsers: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(changeUser)
        print(pastUsers)
        self.view.backgroundColor = UIColor.darkGray
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            print(";;;;;;;;;;;;;;;;;;;;;")
            self.performSegue(withIdentifier: "unique", sender: self)
            //self.dismiss(animated: true, completion: nil)
        })
    }
    
    func setUsers(_ uidFuture: String, uidPast: [String]) {
        self.changeUser = uidFuture
        self.pastUsers = uidPast
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! profile).currentUser = self.changeUser!
        (segue.destination as! profile).pastUsers = self.pastUsers
        
        
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
