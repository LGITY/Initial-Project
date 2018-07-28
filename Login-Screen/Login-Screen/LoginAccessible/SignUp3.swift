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
    
    //activity view image-button, label, & boolean outlets
    @IBOutlet weak var sportsButton: UIButton!
    @IBOutlet weak var sportsLabel: UILabel!
    var sportsPressed = false
    
    @IBOutlet weak var conditioningButton: UIButton!
    @IBOutlet weak var conditioningLabel: UILabel!
    var conditioningPressed = false
    
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var foodLabel: UILabel!
    var foodPressed = false
    
    @IBOutlet weak var chillButton: UIButton!
    @IBOutlet weak var chillLabel: UILabel!
    var chillPressed = false
    
    @IBOutlet weak var tvButton: UIButton!
    @IBOutlet weak var tvLabel: UILabel!
    var tvPressed = false
    
    @IBOutlet weak var partyButton: UIButton!
    @IBOutlet weak var partyLabel: UILabel!
    var partyPressed = false
    
    @IBOutlet weak var studyButton: UIButton!
    @IBOutlet weak var studyLabel: UILabel!
    var studyPressed = false
    
    @IBOutlet weak var concertButton: UIButton!
    @IBOutlet weak var concertLabel: UILabel!
    var concertPressed = false
    
    @IBOutlet weak var careButton: UIButton!
    @IBOutlet weak var careLabel: UILabel!
    var carePressed = false
    
    
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
    
    //activity view button actions
    
    func changeColor(_ button: UIButton, img1: UIImage, img2: UIImage, lb: UILabel, bln : Bool) {
        if !bln {
            button.setImage(img1, for: .normal)
            lb.textColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
        }
        else {
            button.setImage(img2, for: .normal)
            lb.textColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
        }
        
        
    }
    
    @IBAction func partyButton(_ sender: Any) {
        changeColor(partyButton, img1: #imageLiteral(resourceName: "man-in-a-party-dancing-with-people (1)"), img2: #imageLiteral(resourceName: "man-in-a-party-dancing-with-people"), lb: partyLabel, bln: partyPressed)
        partyPressed = !partyPressed
    }
    
    
    @IBAction func sportsButton(_ sender: Any) {
        changeColor(sportsButton, img1: #imageLiteral(resourceName: "ball-of-basketball (3)"), img2: #imageLiteral(resourceName: "ball-of-basketball (2)"), lb: sportsLabel, bln: sportsPressed)
        sportsPressed = !sportsPressed
    }
    
    @IBAction func conditioningButton(_ sender: Any) {
        changeColor(conditioningButton, img1: #imageLiteral(resourceName: "running (1)"), img2: #imageLiteral(resourceName: "running"), lb: conditioningLabel, bln: conditioningPressed)
        conditioningPressed = !conditioningPressed
    }
    
    @IBAction func foodButton(_ sender: Any) {
        changeColor(foodButton, img1: #imageLiteral(resourceName: "restaurant (1)"), img2: #imageLiteral(resourceName: "restaurant"), lb: foodLabel, bln: foodPressed)
        foodPressed = !foodPressed
    }
    
    @IBAction func chillButton(_ sender: Any) {
        changeColor(chillButton, img1: #imageLiteral(resourceName: "relax (2)"), img2: #imageLiteral(resourceName: "relax (1)"), lb: chillLabel, bln: chillPressed)
        chillPressed = !chillPressed
    }
    
    @IBAction func tvButton(_ sender: Any) {
        changeColor(tvButton, img1: #imageLiteral(resourceName: "gamepad-controller (1)"), img2: #imageLiteral(resourceName: "gamepad-controller"), lb: tvLabel, bln: tvPressed)
        tvPressed = !tvPressed
    }
    
    @IBAction func studyButton(_ sender: Any) {
        changeColor(studyButton, img1: #imageLiteral(resourceName: "book (1)"), img2: #imageLiteral(resourceName: "book"), lb: studyLabel, bln: studyPressed)
        studyPressed = !studyPressed
    }
    
    @IBAction func concertButton(_ sender: Any) {
        changeColor(concertButton, img1: #imageLiteral(resourceName: "ticket (1)"), img2: #imageLiteral(resourceName: "ticket"), lb: concertLabel, bln: concertPressed)
        concertPressed = !concertPressed
    }
    
    @IBAction func careButton(_ sender: Any) {
        changeColor(careButton, img1: #imageLiteral(resourceName: "charity (1)"), img2: #imageLiteral(resourceName: "charity"), lb: careLabel, bln: carePressed)
        carePressed = !carePressed
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
