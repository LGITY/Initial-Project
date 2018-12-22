//
//  HomePostCell.swift
//  Login-Screen
//
//  Created by Davis Booth on 11/25/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class HomePostCell: UITableViewCell {

    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeSinceLabel: UILabel!
    
    
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var limitedSpaceLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    
    var ref: DatabaseReference?
    
    var uid: String? {
        didSet {
            setUpUser()
        }
    }
    
    var eid: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
        joinButton.layer.cornerRadius = 10
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        joinButton.backgroundColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
        joinButton.setTitle("Join", for: .normal)
        joinButton.setTitleColor(UIColor.white, for: .normal)
        joinButton.layer.borderWidth = 0
        joinButton.isEnabled = true
    }
    
    func setUpJoined() {
        joinButton.backgroundColor = UIColor.clear
        joinButton.setTitle("✓", for: .normal)
        joinButton.setTitleColor(UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0), for: .normal)
        joinButton.layer.borderColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0).cgColor
        joinButton.layer.borderWidth = 1
        joinButton.isEnabled = false
    }
    
    func setUpUser() {
        ref?.child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! [String: Any]
            print(value)
            self.userName.text = (value["first"] as! String) + " " + (value["last"] as! String)
            let imgUrl = value["prof-pic"] as? String ?? "https://firebasestorage.googleapis.com/v0/b/plusonetest-2143.appspot.com/o/Activity%20Pictures%2Fzzzblank.png?alt=media&token=9be4b2c0-ed13-4248-9d8c-c7e9bce9505d"
            let surl = URL(string: imgUrl)
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
            })
            self.profPic.contentMode = .scaleToFill
            self.profPic.layer.backgroundColor = UIColor.white.withAlphaComponent(0.40).cgColor
            self.profPic.layer.cornerRadius = self.profPic.frame.size.width/2
            self.profPic.clipsToBounds = true
            self.profPic.isHidden = false
        
            ref?.child("Users").child(uid!).child("Events").child(self.eid).child("attendees").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! NSDictionary
                if (value.allValues as! [String]).contains(self.uid!) {
                    self.setUpJoined()
                }
                
            })
        
        
        
    }
    
    func fullInit(_ host: String, evID: String, activity: String, eventName: String, numberParticipants: Int, time: String, loc: String) {
        self.eid = evID
        self.uid = host
        //activityLabel.text = activity
        activityLabel.text = eventName
        limitedSpaceLabel.text = String(numberParticipants) + " spots"
        
        
        // Date formatting stuff
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date1 = dateFormatter.date(from: time)
        dateFormatter.dateFormat = "MMM dd"
        let date2 = dateFormatter.string(from: date1!)
        dateFormatter.dateFormat = "h:mm a"
        let time1 = dateFormatter.string(from: date1!)
        var fullString: String = ""
        fullString.append(date2)
        fullString.append( " @ ")
        fullString.append(time1)
        whenLabel.text = fullString
        whereLabel.text = loc
        timeSinceLabel.text = String(Int((date1?.timeIntervalSinceNow)!)/3600) + " hrs"
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func joinButton(_ sender: Any) {
        let arr = limitedSpaceLabel.text?.split(separator: " ")
        let newParticipants = Int(Int(arr![0])! - 1)
        if newParticipants <= 0 {
            print("!! close this event !!")
        }
        limitedSpaceLabel.text = String(newParticipants) + " spots"
        ref?.child("Users").child(uid!).child("Events").child(eid).child("numParticipants").setValue(String(newParticipants))
        ref?.child("Users").child(uid!).child("Events").child(eid).child("attendees").childByAutoId().setValue(uid!)
        
        print("JOINED")

        setUpJoined()
        
    }
    
    
    @IBAction func moreButton(_ sender: Any) {
    }
    
    
    
}
