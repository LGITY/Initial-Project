//
//  PrivacyPolicy.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/16/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class PrivacyPolicy: UIViewController {

    //background outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //first header outlets
    @IBOutlet weak var head1: UILabel!
    @IBOutlet weak var subHead1: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    //second header outlets
    @IBOutlet weak var header2: UILabel!
    @IBOutlet weak var subHeader2: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var subHeader3: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load background
        backgroundView.backgroundColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
        
        //load navigation bar
        loadNavigationBar()
        
        //load all text
        loadText()
        
        
        // Do any additional setup after loading the view.
    }
    
    func loadNavigationBar() {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
    
    func loadText() {
        let arr = [label1, label2, label3, subHead1, subHeader2, subHeader3, head1, header2]
        
        for t in arr {
            t?.textColor = UIColor.white
        }
        
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
