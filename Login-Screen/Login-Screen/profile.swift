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
    @IBOutlet weak var segmentedControl: SegmentedControl!
    var info: Dictionary<String, String> = [:]
    @IBOutlet weak var scrollView: UIScrollView!
    
    
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
        //passes in a pointer to this view controller that allows for manipulation of it
        segmentedControl.fullInit(view: self)
        
        //allows for the gesture recognition of the swipe left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(profile.respondToSwipeGesture(sender:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        //allows for the gesture recognition of the swipe right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(profile.respondToSwipeGesture(sender:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        
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
    
    @objc func respondToSwipeGesture(sender: UIGestureRecognizer) {
        if let swiped = sender as? UISwipeGestureRecognizer {
            switch swiped.direction {
            case UISwipeGestureRecognizerDirection.left:
                print("GO LEFT GO LEFT")
                segmentedControl.displayNewSelectedIndexSwipeLeft(left: true, view: self)
            case UISwipeGestureRecognizerDirection.right:
                print("Right babe")
                segmentedControl.displayNewSelectedIndexSwipeLeft(left: false, view: self)
            default:
                break
            }
        }
        //segmentedControl.displayNewSelectedInde
    }
    
    //updates the scroll view to show new content -- makes it so that segmented control class can access locally defined scroll view
    func updateScroll(xVal: Int, yVal: Int) {
        scrollView.setContentOffset(CGPoint(x: xVal, y: yVal), animated: true)
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
