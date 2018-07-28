//
//  SignUp3.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/27/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class SignUp3: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    
    //background outlets
    @IBOutlet weak var backgroundPic: UIImageView!
    @IBOutlet weak var backgroundColor: UIView!
    
    //navigation bar outlets
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var skipButton: UIBarButtonItem!
    
    //activity view outlets
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var verticalStack: UIStackView!
    @IBOutlet weak var rowOne: UIStackView!
    @IBOutlet weak var rowTwo: UIStackView!
    @IBOutlet weak var rowThree: UIStackView!
    
    
    //dot outlets
    @IBOutlet weak var dotStack: UIStackView!
    @IBOutlet weak var dotFirst: UIView!
    @IBOutlet weak var dotSecond: UIView!
    @IBOutlet weak var dotThird: UIView!
    @IBOutlet weak var dotFourth: UIView!
    @IBOutlet weak var dotLast: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loads background
        loadBackground()
        
        //load navigation bar
        loadNavigationBar()

        //loads header label
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.white

        
        //loads activity view
        activityView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        activityView.layer.cornerRadius = 10


        //loads dots
        loadDots()

        //loads next button
        nextButton.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }
    
    
    func loadNavigationBar() {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        
        skipButton.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "Futura-Bold", size: 17)!], for: UIControlState.normal)
    }
    
    func loadBackground() {
        //BACKGROUND
        //Sets up the background layer; creates a background rectangle, shades it in, and then adds the image in the background to fill the whole thing
        //let layer = UIView(frame: CGRect(x: -967, y: -214, width: 2337, height: 1547))
        backgroundColor.backgroundColor = UIColor(red:0.03, green:0.12, blue:0.18, alpha:0.7)
        //self.view.addSubview(layer)
        backgroundPic.image = #imageLiteral(resourceName: "sign-up-background")
        backgroundPic.contentMode = .scaleAspectFill
    }
    
    func loadDots() {
        
        //add green dot
        dotThird.backgroundColor = UIColor(red:0.03, green:1, blue:0.52, alpha:1)
        dotThird.layer.cornerRadius = dotFirst.frame.size.width/2
        
        //adds grey dots
        let dotArray = [dotFirst, dotSecond, dotFourth, dotLast] as! [UIView]
        for dot in dotArray {
            dot.backgroundColor = UIColor.lightGray
            dot.layer.cornerRadius = dot.frame.size.width/2
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
