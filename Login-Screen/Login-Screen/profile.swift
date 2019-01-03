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
import CoreLocation


//This class functions as the hub of information for both the internal and external profiles.
//The information that it provides is dependent upon the currentUser variable, which is set to whichever
// users profile is being displayed.
class profile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userInfo : User!
    //navigation bar outlets
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    let dispatchGroup = DispatchGroup()
    var toFriend: String?
    //profile background outlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var usrName: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var divider: UIView!
    
    //below the top of the profile -- FRIEND TAB
    @IBOutlet weak var friendTable: UITableView!
    
    //INTERESTS TAB: outlets for images, labels, and stacks
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var lab2: UILabel!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var lab3: UILabel!
    @IBOutlet weak var stack3: UIStackView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var lab4: UILabel!
    @IBOutlet weak var stack4: UIStackView!
    @IBOutlet weak var stack5: UIStackView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var lab5: UILabel!
    @IBOutlet weak var stack6: UIStackView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var lab6: UILabel!
    @IBOutlet weak var stack7: UIStackView!
    @IBOutlet weak var img7: UIImageView!
    @IBOutlet weak var lab7: UILabel!
    @IBOutlet weak var stack8: UIStackView!
    @IBOutlet weak var img8: UIImageView!
    @IBOutlet weak var lab8: UILabel!
    @IBOutlet weak var stack9: UIStackView!
    @IBOutlet weak var img9: UIImageView!
    @IBOutlet weak var lab9: UILabel!
    @IBOutlet weak var stack10: UIStackView!
    @IBOutlet weak var img10: UIImageView!
    @IBOutlet weak var lab10: UILabel!
    @IBOutlet weak var stack11: UIStackView!
    @IBOutlet weak var img11: UIImageView!
    @IBOutlet weak var lab11: UILabel!
    @IBOutlet weak var stack12: UIStackView!
    @IBOutlet weak var img12: UIImageView!
    @IBOutlet weak var lab12: UILabel!
    
    //arrays to store the images, labels, and vertical stacks for the interests tab
    var imgArray: [UIImageView] = [UIImageView]()

    var labArray: [UILabel] = [UILabel]()

    var stackArray: [UIStackView] = [UIStackView]()

    
    //GROUPS TAB outlets -- only the table view. All other outlets are created by the GroupsCell TableCell
    @IBOutlet weak var groupsTable: UITableView!
    
    
    //Outlets for segmented control configuration
    @IBOutlet weak var segmentedControl: SegmentedControl!
    var info: Dictionary<String, String> = [:]
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentUser: User!
    var pastUsers: [String] = [String]()
    
    @objc func backButton() {
        pastUsers.popLast()!
        let vc: UIViewController = (self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3])!
        self.navigationController?.popToViewController(vc, animated: true)
    }
    //Reference that links up the database from firebase
    var ref: DatabaseReference!
    //Variable that stores the friends list. Every time a friend list is created
    var fList: Dictionary<String, AnyObject> = [:] {
        didSet {
            print("Hey there")
            friendTable.reloadData()
        }
    }
    
    //creates the variable that stores the event list
    var eList: Dictionary<String, AnyObject>?
    
    //creates the variable that stores the group list
    var gList: [String] = [String]() {
        didSet {
            groupsTable.reloadData()
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.imgArray = [img1, img2, img3, img4, img5, img6, img7, img8, img9, img10, img11, img12]
        self.labArray = [lab1, lab2, lab3, lab4, lab5, lab6, lab7, lab8, lab9, lab10, lab11, lab12]
        self.stackArray = [stack1, stack2, stack3, stack4, stack5, stack6, stack7, stack8, stack9, stack10, stack11, stack12]

        for stack in stackArray {
            stack.isHidden = true
            print("hidden !!! ")
        }
        // REGISTERS NIBS

        if pastUsers == []
        {
            debugPrint("Hiding back button")
            self.navigationItem.leftBarButtonItem=nil
            self.navigationItem.hidesBackButton = true
        }
        else
        {
            print("Not hiding back button")
            let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "BackArrowIcon"), style: .done, target: self, action: #selector(backButton))
            self.navigationItem.leftBarButtonItem = addButton
            self.navigationItem.hidesBackButton = false
        }
        //Set up FRIEND Table View Controller
        friendTable.delegate = self
        friendTable.dataSource = self
        
        //Creates the nib for the table view to reference
        let nibName = UINib(nibName: "friendsCell", bundle: nil)
        
        //registers the nib for use with the table view
        friendTable.register(nibName, forCellReuseIdentifier: "friendsCell")
        
        //disables scrollbar in both directions
        friendTable.showsHorizontalScrollIndicator = false
        friendTable.showsVerticalScrollIndicator = false
        
        //getting user information from tab bar controller
        let tabbar = tabBarController as! tabBarController
        userInfo = tabbar.userInfo
        //if this is the first time going to profile screen, grab id from tabbar object

        var userId: String
        if toFriend == nil
        {
            userId = userInfo.id
        }
        else
        {
            userId = toFriend!
        }
        print("USER ID fetching data for: ", userId)
        self.groupsTable.delegate = self
        self.groupsTable.dataSource = self
        
        //Creates the nib for the table view to reference
        let nibName2 = UINib(nibName: "AddGroup", bundle: nil)
        
        //registers the nib for use with the table view
        self.groupsTable.register(nibName2, forCellReuseIdentifier: "AddGroup")
        
        //disables scrollbar in both directions
        self.groupsTable.showsHorizontalScrollIndicator = false
        self.groupsTable.showsVerticalScrollIndicator = false
        
        //Creates the nib for the table view to reference
        let nibName3 = UINib(nibName: "GroupCell", bundle: nil)
        
        //registers the nib for use with the table view
        self.groupsTable.register(nibName3, forCellReuseIdentifier: "GroupCell")
        
        //loads navigation bar
        self.loadNavigationBar()
        
        //loads background pic for profile and shit
        
        self.loadProfBackground()
        
        //creates a reference to the firebase database
        self.ref = Database.database().reference()
        //load segmented control
        //passes in a pointer to this view controller that allows for manipulation of it
        self.segmentedControl.fullInit(view: self)
        
        //allows for the gesture recognition of the swipe left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(profile.respondToSwipeGesture(sender:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        //allows for the gesture recognition of the swipe right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(profile.respondToSwipeGesture(sender:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isDirectionalLockEnabled = true
        
        self.profPic.contentMode = .scaleToFill
        self.profPic.layer.backgroundColor = UIColor.white.withAlphaComponent(0.40).cgColor
        self.profPic.layer.cornerRadius = self.profPic.frame.size.width/2
        self.profPic.clipsToBounds = true
        self.profPic.isHidden = false
        currentUser = User(id: userId, activities: nil, friends: nil, groups: nil)
        currentUser.updateInfo{
        //Set up GROUP Table View Controller
        self.setupView { (result) in
        }
        self.usrName.text = self.currentUser.first! + " " + self.currentUser.last!
        self.usrName.textAlignment = .center
        self.usrName.textColor = UIColor.white

        for group in (self.currentUser.groups)!.keys
        {
            self.gList.append(group)
        }
        
        }
        
    
    }
    
    
    func loadProfBackground() {
        backgroundImage.image = #imageLiteral(resourceName: "login")
    }
    
    func loadNavigationBar() {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        
    }
    
    func setupInterests() {
        //gets the information about the user's interests and the count of how many interests they had
        if let interests = currentUser.activities {
            let count = interests.count
            var status = 0
            while status < count {
                stackArray[status].isHidden = false
                imgArray[status].image = UIImage(named: interests[status])
                imgArray[status].contentMode = .scaleAspectFit
                labArray[status].text = interests[status].capitalized
                status += 1
                print("activity " + String(status))
            }
        }
    }
    
    func setupView(_ completion: (Bool) -> Void) {
            print("finished execution of all users")
            self.fList = self.currentUser.friends!
            let urlPath = self.currentUser.profPic
            if let profUrl = urlPath {
                let surl = URL(string: profUrl)
                let url = URLRequest(url: surl!)
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error as! String)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.profPic.image = UIImage(data: data!)
                    }
                    
                    }.resume()
            }

            
            //load profile picture label
            let fst = self.currentUser.first!
            let lst = self.currentUser.last!
            self.usrName.text = fst + " " + lst
            self.usrName.textAlignment = .center
            self.usrName.textColor = UIColor.white
            
            //set up friends label
            self.friendsLabel.textColor = UIColor.white

            self.friendsLabel.text = String(self.fList.count) + " FRIENDS"
        
            //set up events label
            self.eventsLabel.textColor = UIColor.white
            self.eList = self.currentUser.events!
            self.eventsLabel.text = String(self.eList!.count) + " EVENTS"
            self.setupInterests()
    }
    
    @objc func respondToSwipeGesture(sender: UIGestureRecognizer) {
        if let swiped = sender as? UISwipeGestureRecognizer {
            switch swiped.direction {
            case UISwipeGestureRecognizerDirection.left:
                segmentedControl.displayNewSelectedIndexSwipeLeft(left: true, view: self)
            case UISwipeGestureRecognizerDirection.right:
                segmentedControl.displayNewSelectedIndexSwipeLeft(left: false, view: self)
            default:
                break
            }
        }
    }
    
    //updates the scroll view to show new content -- makes it so that segmented control class can access locally defined scroll view
    func updateScroll(xVal: Int, yVal: Int) {
        scrollView.setContentOffset(CGPoint(x: xVal, y: yVal), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == friendTable {
            return self.fList.count
        }
        else {
            return self.gList.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == friendTable {
            //dequeus the cell that we created and styled in the xib file for reuse
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! friendsCell
            let usr = Array(fList.keys)[indexPath.item]
            let dict = fList[usr] as? NSDictionary
            let localUsername = dict!["username"] as! String
            let localName = (dict!["first"] as? String)! + " " + (dict!["last"] as? String)!
            cell.commonInit(name: localName, username: localUsername)
            return cell
        }
        else {
            if indexPath.item == 0 {
                //dequeus the cell that we created and styled in the xib file for reuse
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddGroup", for: indexPath) as! AddGroup
                cell.fullInit(view: self)
                return cell
            }
            else {
                if gList.count+1 > indexPath.item {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
                    var tName = ""
                    ref?.child("Groups").child(gList[indexPath.item-1]).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as! NSDictionary
                        tName = value["name"] as! String
                        var tMembers = [String]()
                        self.ref?.child("Groups").child(self.gList[indexPath.item-1]).observeSingleEvent(of: .value, with: { (snapshot) in
                                let value = snapshot.value as? NSDictionary
                                tMembers = value?["members"] as! [String]
                                cell.commonInit(self.gList[indexPath.item-1], name: tName, members: tMembers)
                            })

                    })
                    return cell
                }
                else {
                    return UITableViewCell()
                }
            }
        }
    }
    
    //returns the height of the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //make sure to change this function to make it robust to clicks out of range
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == groupsTable {
            GroupSpec.gid = self.gList[indexPath.item-1]
            self.performSegue(withIdentifier: "toGroupSpec", sender: self)
        }
        else {
            self.toFriend = Array(fList.keys)[indexPath.item]
            pastUsers.append(currentUser.id)
            self.currentUser = User(id: self.toFriend!, activities: nil, friends: nil, groups: nil)
            self.performSegue(withIdentifier: "toTransition", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? profTransitionVC{
            destinationViewController.toFriend = self.toFriend
            destinationViewController.pastUsers = self.pastUsers
        }
    }
}
