//
//  settings.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/28/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class settings: UIViewController {

    //navigation bar outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    //settings outlets
    @IBOutlet weak var sampleSwitch: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load naviation bar
        loadNavigationBar()
        // Do any additional setup after loading the view.
        sampleSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
    }
    
    func loadNavigationBar() {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        
        saveButton.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "Futura-Bold", size: 14)!], for: UIControlState.normal)
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
