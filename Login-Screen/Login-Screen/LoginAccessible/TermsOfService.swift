//
//  TermsOfService.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/16/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class TermsOfService: UIViewController {
    
    //background elements
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    // first heading outlets
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var subHead1: UILabel!
    @IBOutlet weak var head1: UILabel!
    
    // second heading outlets
    @IBOutlet weak var head2: UILabel!
    @IBOutlet weak var subHead2: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var subHead3: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //loads background color
        backgroundView.backgroundColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
        
        //loads navigation bar
        loadNavigationBar()
        
        
        //loads all description
        loadText()
    }
    
    func loadNavigationBar() {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
    
    func loadText() {
        let arr = [label1, label2, label3, subHead1, subHead2, subHead3, head1, head2]
        
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
