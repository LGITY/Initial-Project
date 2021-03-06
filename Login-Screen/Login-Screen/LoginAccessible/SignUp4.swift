//
//  SignUp4.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/30/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import Contacts
import FirebaseDatabase
import Firebase
import FacebookLogin
import FBSDKLoginKit

class SignUp4: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var backgroundColor: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var backgroundTable: UIView!
    
    @IBOutlet weak var friendTable: UITableView!

    @IBOutlet weak var dotStack: UIStackView!
    @IBOutlet weak var dotFirst: UIView!
    @IBOutlet weak var dotSecond: UIView!
    @IBOutlet weak var dotThird: UIView!
    @IBOutlet weak var dotFourth: UIView!
    @IBOutlet weak var dotLast: UIView!

    @IBOutlet weak var nextButton: UIButton!

    //Firebase outlets

    //Reference that links up the database
    var ref: DatabaseReference!

    //Database Handle that specifies the listener connection
    var databaseHandle: DatabaseHandle?

    //contacts variables
    var contactsLocal: Dictionary = [String:[String]]()
    var contactsCloud = [[String]]()
    var contactsToImport: Dictionary = [String:[String]]() {
        didSet {
            friendTable.reloadData()
        }
    }
    var contactsFound: Dictionary = [String:[String]]() {
        didSet {
            friendTable.reloadData()
        }
    }
    
    
    //dictionary that carries information from page to page
    var info: NSMutableDictionary = [:]
    var dict : [String : AnyObject]!



    override func viewDidLoad() {
        print("signUp4 info: ", info)

        super.viewDidLoad()
        // ALL LAYOUT SETUP //
        
        //adds a friend list to the info array
        info["friendList"] = [String]()
        
        //loads background
        loadBackground()

        //load navigation bar
        loadNavigationBar()

        //loads header label
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.white


        //loads friend table view
        backgroundTable.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        backgroundTable.layer.cornerRadius = 10
        friendTable.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        friendTable.layer.cornerRadius = 10


        //loads dots
        loadDots()

        //loads next button
        nextButton.layer.cornerRadius = 15

        //Set up Table View Controller
        friendTable.delegate = self
        friendTable.dataSource = self

        //Creates the nib for the table view to reference
        let nibName = UINib(nibName: "AddFriendCell", bundle: nil)

        //registers the nib for use with the table view
        friendTable.register(nibName, forCellReuseIdentifier: "AddFriendCell")

        //disables scrollbar in both directions
        friendTable.showsHorizontalScrollIndicator = false
        friendTable.showsVerticalScrollIndicator = false

        ref = Database.database().reference()
        
//        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
//        loginButton.center = view.center
//        loginButton.frame = CGRect(x:100, y:60, width:loginButton.frame.width, height:loginButton.frame.height)
//
//        //adding it to view
//        view.addSubview(loginButton)

        fetchContacts { (result) in
            if result {
                friendTable.reloadData()
            }
        }
        
        //imports already created usernames to userArray
        self.ref?.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let bchild = child as! DataSnapshot
                let achild = bchild.value as! [String: Any]
                let phone = achild["phone"] as? String
                let usr = achild["username"] as! String
                var arr = [String]()
                if let ph = phone {
                    //arr = [ph,usr]
                    arr = [ph, bchild.key]
                }
                else {
                    //arr = ["", usr]
                    arr = ["", bchild.key]
                }
                self.contactsCloud.append(arr)
            }
        })
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        let email = info["email"]
        let pass = info["password"]
        Auth.auth().createUser(withEmail: email as! String, password: pass as! String, completion: {(user, error) in
            if user != nil {
                //makes user on authentication tab on firebase
                print("madeUser")
                
                //creates the user with the username specified in the database
                //        let valArray =  ["username" : self.usernameTextView.text,"email" : self.emailTextView.text] as! [String: String]
                //HOLY SHIT THAT IS EASY
                self.ref?.child("Users").child((user?.user.uid)!).setValue(self.info)
                
                //sets the global User variable's uid component to the user's ID
                SignUp1.User.uid = (user?.user.uid)!
                
                self.performSegue(withIdentifier: "toSignUp5", sender: self)
            }
        }
        )
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //method needed to be done to allow Fibrebase API
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    func loadNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white

        //skipButton.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "Futura-Bold", size: 17)!], for: UIControlState.normal)
    }

    func loadBackground() {
        //BACKGROUND
        //Sets up the background layer; creates a background rectangle, shades it in, and then adds the image in the background to fill the whole thing
        //let layer = UIView(frame: CGRect(x: -967, y: -214, width: 2337, height: 1547))
        backgroundColor.backgroundColor = UIColor(red:0.03, green:0.12, blue:0.18, alpha:0.7)
        //self.view.addSubview(layer)
        backgroundImage.image = #imageLiteral(resourceName: "sign-up-background")
        backgroundImage.contentMode = .scaleAspectFill
    }

    func loadDots() {

        //add green dot
        dotFourth.backgroundColor = UIColor(red:0.03, green:1, blue:0.52, alpha:1)
        dotFourth.layer.cornerRadius = dotFirst.frame.size.width/2

        //adds grey dots
        let dotArray = [dotFirst, dotSecond, dotThird, dotLast] as! [UIView]
        for dot in dotArray {
            dot.backgroundColor = UIColor.lightGray
            dot.layer.cornerRadius = dot.frame.size.width/2
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //decides if the users are PlusOnes yet ot not
        for key in contactsLocal.keys {
            let numberList = contactsLocal[key]
            //determines if the user has a plus one
            var found = false
            for number in numberList! {
                print("In table loop")
                for ct in self.contactsCloud {
                    if number == ct[0] || ct[0].contains(number) {
                        var val = info["friendList"] as! [String]
                        val.append(ct[1])
                        info["friendList"] = val
                        found = true
                    }
                }
                if !found {
                    print("Contact needs to be imported")
                    contactsToImport[key] = numberList
                }
                else {
                    contactsFound[key] = numberList
                }
            }
        }
        friendTable.reloadData()
    }

    func fetchContacts(_ completion: (Bool) -> Void) {
        let store = CNContactStore()

        store.requestAccess(for: .contacts) { (granted, error) in
            if let err = error {
                print("Failed to request access")
                print(err)
                return
            }

            if granted {
                print("Bang")

                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

                do {

                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPoint) in
                        let fullName = contact.givenName + " " + contact.familyName

                        let rawNumbers = contact.phoneNumbers
                        var toAppend = [String]()

                        for n in rawNumbers {
                            toAppend.append(n.value.value(forKey: "digits") as! String)
                        }

                        //print(toAppend)
                        self.contactsLocal[fullName] = toAppend
                        print(self.contactsLocal.count)
                    })

                }
                catch let err {
                    print("BLAH", err)
                }


            }
            else {
                print("access denied")
            }
        }
    }

    //returns the height of the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.contactsToImport.values)
        return self.contactsToImport.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeus the cell that we created and styled in the xib file for reuse
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendCell", for: indexPath) as! AddFriendCell

        let contactsKeyRawUnstring = self.contactsToImport.keys.sorted()
        var contactsKeyString = [String]()
        for k in contactsKeyRawUnstring {
            contactsKeyString.append(k)
        }

        let contactsKey = contactsKeyString[indexPath.item]
        let contactsValue = contactsToImport[contactsKey]
        var contactsValFinal = [String]()
        for val in contactsValue! {
            var toAppend = ""
            if !val.contains("+") {
                toAppend = "+1" + val
                contactsValFinal.append(toAppend)
            }
            else {
                contactsValFinal.append(val)
            }
        }
        print(contactsValFinal)
        
        cell.commonInit(name: contactsKey, phone: contactsValFinal)
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



