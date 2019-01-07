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

class HomePostCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var commentLabel: UIButton!
    @IBOutlet weak var moreTable: UITableView!
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var showAttendeesButton: UIButton!
    var attendeesShowing = false
    
    @IBOutlet weak var separator: UIView!
    
    var colView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), collectionViewLayout: UICollectionViewFlowLayout.init())
    //var colView = UILabel()
    
    var ref: DatabaseReference?
    
    var uid: String? {
        didSet {
            setUpUser()
        }
    }
    
    var attendeesArr: [String] = [] {
        didSet {
            colView.reloadData()
        }
    }
    
    var eid: String = ""
    var eventType: String?
    var isPublic: Bool?
    var parentViewController: UIViewController?
    var indexPath: IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
        joinButton.layer.cornerRadius = 10
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.colView.translatesAutoresizingMaskIntoConstraints = false
        colView.backgroundColor = UIColor.white
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
        separator.backgroundColor = UIColor(red:0.33, green:0.34, blue:0.36, alpha:1)
        //collectionView.backgroundColor = UIColor.black
        
        // Creates and registers nib.
        self.colView.register(UINib.init(nibName: "attendeesCell", bundle: nil), forCellWithReuseIdentifier: "attendeesCell")
        colView.delegate = self
        colView.dataSource = self
        
        // Disables scrollbars.
        colView.showsHorizontalScrollIndicator = false
        colView.showsVerticalScrollIndicator = false
        colView.alwaysBounceVertical = false
        
        let toSet = "> 0 going"
        self.showAttendeesButton.setTitle(toSet, for: .normal)
        
        
    }
    
    func setUpJoined() {
        joinButton.backgroundColor = UIColor.clear
        joinButton.setTitle("JOINED", for: .normal)
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
            if !isPublic! {
                ref?.child("Events").child(self.eid).child("attendees").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if let value2 = value {
                        if (value2.allValues as! [String]).contains(SignUp1.User.uid) {
                            self.setUpJoined()
                        }
                        self.attendeesArr = value2.allValues as! [String]
                        let toSet = "> " + String(value2.count) + " going"
                        self.showAttendeesButton.setTitle(toSet, for: .normal)
                    }
                    
                })
            }
            else {
                ref?.child("Public Events").child(self.eventType!).child(self.eid).child("attendees").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if let value2 = value {
                        if (value2.allValues as! [String]).contains(SignUp1.User.uid) {
                            self.setUpJoined()
                        }
                        self.attendeesArr = value2.allValues as! [String]
                        let toSet = "> " + String(value2.count) + " going"
                        self.showAttendeesButton.setTitle(toSet, for: .normal)
                    }
                    
                })
            }
        
        
        
    }
    
    func fullInit(_ host: String, evID: String, activity: String, eventName: String, numberParticipants: Int, time: String, loc: String, numComments: Int, isPublic: Bool? = false, parentView: UIViewController, indexPath: IndexPath) {
        self.eid = evID
        self.eventType = activity
        self.isPublic = isPublic
        self.uid = host
        self.indexPath = indexPath
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
        timeSinceLabel.text = "Starts in " + String(Int((date1?.timeIntervalSinceNow)!)/3600) + " hrs"
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
        if !isPublic! {
            ref?.child("Events").child(eid).child("numParticipants").setValue(String(newParticipants))
            ref?.child("Events").child(eid).child("attendees").childByAutoId().setValue(SignUp1.User.uid)
        }
        else {
            ref?.child("Public Events").child(self.eventType!).child(eid).child("numParticipants").setValue(String(newParticipants))
            ref?.child("Public Events").child(self.eventType!).child(eid).child("attendees").childByAutoId().setValue(SignUp1.User.uid)
        }
        
        print("JOINED")

        setUpJoined()
        
    }
    
    @IBAction func showAttendeesButton(_ sender: Any) {
        let label = self.showAttendeesButton.titleLabel!.text!
        if colView.window == nil {
            self.addSubview(colView)
            let c1 = NSLayoutConstraint(item: self.colView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50)
            let c2 = NSLayoutConstraint(item: self.colView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
            let c3 = NSLayoutConstraint(item: self.colView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 5)
            let c4 = NSLayoutConstraint(item: self.colView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal, toItem: stackView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 5)
            let c5 = NSLayoutConstraint(item: self.colView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
            self.addConstraint(c1)
            self.addConstraint(c2)
            self.addConstraint(c3)
            self.addConstraint(c4)
            self.addConstraint(c5)
            let newString = "v" + label.suffix(from: label.index(label.startIndex, offsetBy: 1))
            self.showAttendeesButton.setTitle(newString, for: .normal)
            
        }
        else {
            colView.removeFromSuperview()
            let newString = ">" + label.suffix(from: label.index(label.startIndex, offsetBy: 1))
            self.showAttendeesButton.setTitle(newString, for: .normal)
        }
        self.attendeesShowing = !self.attendeesShowing
        self.isSelected = !self.isSelected
        
        // For home.
        (self.parentViewController as? Home)?.mainTableView?.beginUpdates()
        (self.parentViewController as? Home)?.mainTableView?.endUpdates()
        
        // For in my area.
        (self.parentViewController as? GeoSport)?.tableView?.beginUpdates()
        (self.parentViewController as? GeoSport)?.tableView?.endUpdates()
        
    }
    
    
    @IBAction func commentButton(_ sender: Any) {
        (parentViewController as? Home)?.transitionInfo = eid
        (parentViewController as? GeoSport)?.transitionInfo = eid
        (parentViewController as? GeoSport)?.eventType = self.eventType
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

extension HomePostCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendeesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attendeesCell", for: indexPath as IndexPath) as! attendeesCell
        let thisCell = attendeesArr[indexPath.item]
        cell.fullInit(thisCell)
        return cell
    }
    
    // Determines size of CollectionViewCells.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colView.frame.height, height: colView.frame.height)
    }
    
//    // Perform segue to SportGeo upon tap.
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        parentViewController?.syntheticPerform(activityArr[indexPath.item])
//    }
}
