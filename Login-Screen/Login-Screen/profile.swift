//
//  profile.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/29/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase

class profile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
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
    
    //below the top of the profile
    @IBOutlet weak var friendTable: UITableView!
    
    
    //selector gadget
    @IBOutlet weak var segmentedControl: SegmentedControl!
    var info: Dictionary<String, String> = [:]
    @IBOutlet weak var scrollView: UIScrollView!
    
    //stores the current user's uid locally
    let currentUser = SignUp1.User.uid
    
    //Reference that links up the database
    var ref: DatabaseReference!
    
    //creates the variable that stores the friends list
    var fList: [String] = [] {
        didSet {
            print("Hey there")
            friendTable.reloadData()
        }
    }
    
    //creates the variable that stores the event list
    var eList: [String: String] = [:]
    
    override func viewDidLoad() {
        
        //SUPER VIEW DID LOAD
        super.viewDidLoad()

        
        // REGISTERS NIB
        
        
        //Set up Table View Controller
        friendTable.delegate = self
        friendTable.dataSource = self
        
        //Creates the nib for the table view to reference
        let nibName = UINib(nibName: "friendsCell", bundle: nil)
        
        //registers the nib for use with the table view
        friendTable.register(nibName, forCellReuseIdentifier: "friendsCell")
        
        //disables scrollbar in both directions
        friendTable.showsHorizontalScrollIndicator = false
        friendTable.showsVerticalScrollIndicator = false
        
        //loads navigation bar
        loadNavigationBar()
        
        //loads background pic for profile and shit
        loadProfBackground()
        
        //creates a reference to the firebase database
        ref = Database.database().reference()
        
        //creates storage reference
        let storage = Storage.storage()
        
//        fetchUIDs { (result) in
//            if result {
//                friendTable.reloadData()
//            }
//        }
        
        //load profile picture image
        
        //TO DO: to figure out how to mke the user's easily accessible
        //profPic.image = ref.child("Users")
        
        setupView { (result) in
            if result {
            }
        }
        
        
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
        print("REAL FRIEND LIST   ")
        print(self.fList)
    }
    
    
    func loadProfBackground() {
        backgroundImage.image = #imageLiteral(resourceName: "login")
    }
    
    func loadNavigationBar() {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        
    }
    
    func setupView(_ completion: (Bool) -> Void) {
        self.ref?.child("Users").observe(.value, with: { (snapshot) in
            let toSet:NSMutableDictionary = [:]
            let oValue = snapshot.value as? NSDictionary
            
            for key in (oValue?.keyEnumerator())! {
                // Get user value
                let tKey = key as! String
                print(tKey)
                self.ref?.child("Users").child(tKey).observe(.value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let username = value?["username"] as? String ?? ""
                    print(username)
                    toSet[username] = tKey
                })
            }
            SignUp1.User.allUsers = toSet
            print("finished execution of all users")
        // THIS CODE SEGMENT IMPORTS ALL RELEVANT INFORMATION ABOUT THE USER. NEEDS TO BE SOMEWHERE THAT IS RUN EVERY TIME THE APP LAUNCHES
            self.ref?.child("Users").child(self.currentUser).observe(.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            SignUp1.User.userInfo = value as! NSMutableDictionary
            self.fList = SignUp1.User.userInfo["friendList"] as? [String] ?? [String]()
            
            let urlPath = SignUp1.User.userInfo["prof-pic"] as? String
            if let profUrl = urlPath {
                let surl = URL(string: profUrl)
                let url = URLRequest(url: surl!)
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.profPic.image = UIImage(data: data!)
                    }
                    
                    }.resume()
            }
            self.profPic.contentMode = .scaleToFill
            self.profPic.layer.backgroundColor = UIColor.white.withAlphaComponent(0.40).cgColor
            self.profPic.layer.cornerRadius = self.profPic.frame.size.width/2
            self.profPic.clipsToBounds = true
            self.profPic.isHidden = false
            
            //load profile picture label
            let fst = SignUp1.User.userInfo["first"] as? String ?? ""
            let lst = SignUp1.User.userInfo["last"] as? String ?? ""
            self.usrName.text = fst + " " + lst
            self.usrName.textAlignment = .center
            self.usrName.textColor = UIColor.white
            
            //set up friends label
            self.friendsLabel.textColor = UIColor.white
            
            print(self.fList)
            print("THIS IS THE USER INFORMATION BITCH")
            self.friendsLabel.text = String(self.fList.count) + " FRIENDS"
            
            
            //set up events label
            self.eventsLabel.textColor = UIColor.white
            self.eList = SignUp1.User.userInfo["events"] as? [String: String] ?? [:]
            self.eventsLabel.text = String(self.eList.count) + " EVENTS"
        })
        })
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.fList.count)
        print("FRIEND LIST COUNT ^^")
        return self.fList.count
        //return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeus the cell that we created and styled in the xib file for reuse
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! friendsCell
        
        let usr = fList[indexPath.item]
        print("fetching user: " + usr)
        let uid = SignUp1.User.allUsers[usr] as? String ??  ""
        print("fetching UID: " + uid)
        var localName = ""
        var localUsername = ""
        if uid != "" {
            print("success")
            self.ref?.child("Users").child(uid).observe(.value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                localUsername = usr
                localName = (value?["first"] as? String ?? "") + " " + (value?["last"] as? String ?? "")
                cell.commonInit(name: localName, username: localUsername)
            })
        }
        print("Username:: " + localUsername)
        print("Name:: " + localName)
        return cell
    }
    
    //returns the height of the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
