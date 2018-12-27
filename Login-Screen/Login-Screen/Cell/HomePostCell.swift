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

class HomePostCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    
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
    
    @IBOutlet weak var commentLabel: UIButton!
    @IBOutlet weak var moreTable: UITableView!
    
    var ref: DatabaseReference?
    
    var uid: String? {
        didSet {
            setUpUser()
        }
    }
    
    var eid: String = ""
    
    var parentViewController: Home?
    
    
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
        
        let nibName = UINib(nibName: "MoreCell", bundle: nil)
        moreTable.register(nibName, forCellReuseIdentifier: "moreCell")
        moreTable.delegate = self
        moreTable.dataSource = self
        moreTable.isHidden = true
        moreTable.layer.cornerRadius = 5
        
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
                    print(error as? String)
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
        
            ref?.child("Events").child(self.eid).child("attendees").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let value2 = value {
                    if (value2.allValues as! [String]).contains(SignUp1.User.uid) {
                        self.setUpJoined()
                    }
                }
                
            })
        
        
        
    }
    
    func fullInit(_ host: String, evID: String, activity: String, eventName: String, numberParticipants: Int, time: String, loc: String, numComments: Int, parentView: Home) {
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
        commentLabel.setTitle(String(numComments) + " comments", for: .normal)
        self.parentViewController = parentView
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
        ref?.child("Events").child(eid).child("numParticipants").setValue(String(newParticipants))
        ref?.child("Events").child(eid).child("attendees").childByAutoId().setValue(uid!)
        
        print("JOINED")

        setUpJoined()
        
    }
    
    @IBAction func commentButton(_ sender: Any) {
        parentViewController?.transitionInfo = eid
        parentViewController?.performSegue(withIdentifier: "toComments", sender: parentViewController)
        
    }
    
    @IBAction func shareButton(_ sender: Any) {
       let activityController = UIActivityViewController(activityItems: ["blah"], applicationActivities: nil)
        
        self.parentViewController!.present(activityController, animated: true)
    }
    
    
    @IBAction func moreButton(_ sender: Any) {
        moreTable.isHidden = !moreTable.isHidden
    }
}

extension HomePostCell {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moreTable.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as! MoreCell
        if indexPath.item == 0 {
            cell.fullInit("Delete Post", parent: self)
        }
        else {
            cell.fullInit("Edit Post", parent: self)
        }
        return cell
    }
}
