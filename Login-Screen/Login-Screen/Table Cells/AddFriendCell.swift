//
//  AddFriendCell.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/5/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class AddFriendCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var phoneNumber = [String]()
    
    
    var pressed = true
    
    //Firebase database reference
    var ref: DatabaseReference!
    
    //temporary variable to  simulate the dictionary of usernames mapped to uids
    var dict = [String: String]()
    
    //temporary variable to simulate the userid of the current user

    
    override func awakeFromNib() {
        super.awakeFromNib()
        //reference implementation for Firebase Database
        ref = Database.database().reference()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //this function basically just acts as a constructor to set everything up (strictly for ease instead of doing it manually
    func commonInit(name: String, username: String = "", phone: [String] = [String]()) {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        nameLabel.text = name
        usernameLabel.text = username
        phoneNumber = phone
        addButton.layer.cornerRadius = 10
        addButton.layer.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1).cgColor
        addButton.setTitle("+INVITE", for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
    }
    @IBAction func addButton(_ sender: Any) {
        if pressed {
            
            // SENDS INVITE
            for phone in phoneNumber {
                let headers = [
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                
                let parameters: Parameters = [
                    "To": phone,
                    "Body": "Davis Booth invited you to PlusOne! Download now"
                ]
                
                Alamofire.request("https://gainsboro-eagle-9593.twil.io/invitetext", method: .post, parameters: parameters, headers: headers).response { response in
                    print(response)
                    
                }
                
                let parameters2: Parameters = [
                    "To": phone,
                    "Body": "https://getplusoneapp.page.link/Tn65"
                ]
                
                Alamofire.request("https://gainsboro-eagle-9593.twil.io/invitetext", method: .post, parameters: parameters2, headers: headers).response { response in
                    print(response)
                    
                }
            }
            
            // CHANGES VISUAL CONTENT OF BUTTON
            addButton.layer.cornerRadius = 1
            addButton.layer.backgroundColor = UIColor.lightGray.cgColor
            addButton.setTitle("INVITED", for: .normal)
            addButton.setTitleColor(UIColor.white, for: .normal)
        }
        else {
            addButton.layer.cornerRadius = 10
            addButton.layer.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1).cgColor
            addButton.setTitle("+INVITE", for: .normal)
            addButton.setTitleColor(UIColor.white, for: .normal)
        }
        pressed = !pressed
        
    }
    
}
