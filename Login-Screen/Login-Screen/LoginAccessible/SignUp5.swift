//
//  SignUp5.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/20/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class SignUp5: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
//            // Your code with delay
//        }
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            self.performSegue(withIdentifier: "toHome", sender: self)
        }
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
