//
//  addFriendsToGroup.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/23/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class addFriendsToGroup: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var ref: DatabaseReference!
    
    var memberList: Set<String> = []
    var userID: String = ""
    var isBlue = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
        
        // Initialization code
    }
    
    func fullInit(memberList: Set<String>, userID: String) {
        self.memberList = memberList
        self.userID = userID
        
        self.ref?.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let name = (value?["first"] as? String ?? "") + " " + (value?["last"] as? String ?? "")
            self.label.text = name
            let urlPath = value?["prof-pic"] as? String
            if let profUrl = urlPath {
                let surl = URL(string: profUrl)
                let url = URLRequest(url: surl!)
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.profPic.image = UIImage(data: data!)
                    }
                    
                    }.resume()
            }

        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addButton(_ sender: Any) {
        if !isBlue {
            addButton.setImage(#imageLiteral(resourceName: "checked-1"), for: .normal)
            //GroupCreation.Members.membList.insert(userID)
            self.memberList.insert(userID)
            print("ADDED !! ")
        }
        else {
            addButton.setImage(#imageLiteral(resourceName: "unchecked-1"), for: .normal)
            //GroupCreation.Members.membList.remove(userID)
            self.memberList.remove(userID)
            print("DELETED !! ")
        }
        isBlue = !isBlue
    }
}
