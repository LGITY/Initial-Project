//
//  GroupCreation.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/23/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase

class GroupCreation: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addPicture: UIView!
    @IBOutlet weak var friendTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var ref: DatabaseReference?
    
    
    var fList: [String] = [String]() {
        didSet {
            friendTable.reloadData()
        }
    }
    struct Members {
        static var membList: Set<String> = []
    }
    var dictToAdd: NSMutableDictionary = [:]
    
    var gID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.addPic (_:)))
        self.addPicture.addGestureRecognizer(gesture)
        
        
        self.fList = SignUp1.User.userInfo["friendList"] as? [String] ?? [String]()
        imageView.isHidden = true
        ref = Database.database().reference()
        
        // REGISTERS NIBS
        
        
        //Set up FRIEND Table View Controller
        friendTable.delegate = self
        friendTable.dataSource = self
        
        //Creates the nib for the table view to reference
        let nibName = UINib(nibName: "addFriendsToGroup", bundle: nil)
        
        //registers the nib for use with the table view
        friendTable.register(nibName, forCellReuseIdentifier: "addFriendsToGroup")
        
        //disables scrollbar in both directions
        friendTable.showsHorizontalScrollIndicator = false
        friendTable.showsVerticalScrollIndicator = false
        
        // Do any additional setup after loading the view.
        
        //adds the user creating the group to the list of users that are members of the group
        Members.membList.insert(SignUp1.User.uid)
    }
    
    @objc func addPic(_ sender:UITapGestureRecognizer){
        print("success !! ")
        // do other task
        var image = UIImagePickerController()
        image.delegate = self
        image.allowsEditing = false
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(image, animated: true, completion: nil)
        
    }
    
    
    // ################ #### #  # #   #  # CHOPPY -- MAKE SURE TO LOOK OVER ####### ## ## ##### ### ### ### ##### ##
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //creates a group id
        gID = self.ref?.child("Groups").childByAutoId().key
        
        
        //CHANGE THIS TO USER ID NOT USERNAME -- FOR SECURITY PURPOSES
        let storage = Storage.storage().reference().child("group-pics").child(gID!)
        self.dictToAdd["group-pic"] = "https://firebasestorage.googleapis.com/v0/b/plusonetest-2143.appspot.com/o/profile-pics%2F600px-Default_profile_picture_(male)_on_Facebook.jpg?alt=media&token=90b055dd-7419-4928-b4bc-6ed67e485657"
        let theInfo: NSDictionary = info as NSDictionary
        if let img:UIImage = theInfo.object(forKey: UIImagePickerControllerOriginalImage) as? UIImage {
            self.dismiss(animated: true, completion: nil)
            //represents image as png for upload
            if let uploadableImage = UIImagePNGRepresentation(img) {
                //throws data to firebase
                storage.putData(uploadableImage, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    else {
                        storage.downloadURL(completion: { (url, error) in
                            if error != nil {
                                print(error as! String)
                                return
                            }
                            else {
                                self.dictToAdd["group-pic"] = url?.absoluteString
                            }
                            
                        })
                    }
                    
                })
                
            }
            
            imageView.image = img
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isHidden = false
        }
        else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeus the cell that we created and styled in the xib file for reuse
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFriendsToGroup", for: indexPath) as! addFriendsToGroup
        
        let usr = fList[indexPath.item]
        print("fetching user: " + usr)
        let uid = SignUp1.User.allUsers[usr] as? String ??  ""
        cell.fullInit(memberList: Members.membList, userID: uid)
       
        return cell
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let arr = Array(Members.membList)
        print("Member list")
        print(Members.membList)
        print("arr")
        print(arr)
        dictToAdd["members"] = arr
        dictToAdd["description"] = descriptionTextField.text
        dictToAdd["name"] = nameTextField.text
        
        // Creates group as an entity
        self.ref?.child("Groups").child(gID!).setValue(self.dictToAdd)
        
        // Adds group to each user's groups variable
        for member in Members.membList {
            self.ref?.child("Users").child(member).child("groups").child(gID!).setValue("group")
        }
        
        //clears Members list
        Members.membList.removeAll()
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
