//
//  CommentsCell.swift
//  Login-Screen
//
//  Created by Davis Booth on 12/25/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CommentsCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var commentID : String?
    var ref: DatabaseReference?
    var isPublic: Bool?
    var eventType: String?
    var parentView: CommentsView? {
        didSet {
            determineLikes()
        }
    }
    var liked: Bool = false
    
    var profURL : String? {
        didSet {
            downloadPic()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.none
        ref = Database.database().reference()
        
        let origImage = #imageLiteral(resourceName: "up-arrow")
        let tintedImage = origImage.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        likeButton.setImage(tintedImage, for: .normal)
        likeButton.tintColor = UIColor.lightGray
        
    }
    
    func fullInit(_ userID : String, commentID: String, comment: String, time: String, likes: String, isPublic: Bool? = false, eventType: String? = nil, parent: CommentsView) {
        self.isPublic = isPublic
        self.eventType = eventType
        self.commentID = commentID
        ref?.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! [String : Any]
            let name = (value["first"] as? String ?? "") + "  " + (value["last"] as? String ?? "")
            self.name.text = name
            self.profURL = value["prof-pic"] as? String ?? ""
        })
        self.comment.text = comment
        self.parentView = parent
    }
    
    func determineLikes() {
        if !isPublic! {
            self.ref?.child("Events").child(parentView!.eid!).child("comments").child(commentID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! [String: Any]
                if value.keys.contains("likes") {
                    let likes = value["likes"] as! [String : String]
                    if likes.keys.contains(SignUp1.User.uid) {
                        self.liked = true
                        self.likeButton.tintColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
                    }
                    self.numLikes.text = String(likes.count)
                }
                else {
                    self.numLikes.text = "0"
                }
            })
        }
        else {
            self.ref?.child("Public Events").child(self.eventType!).child(parentView!.eid!).child("comments").child(commentID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! [String: Any]
                if value.keys.contains("likes") {
                    let likes = value["likes"] as! [String : String]
                    if likes.keys.contains(SignUp1.User.uid) {
                        self.liked = true
                        self.likeButton.tintColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
                    }
                    self.numLikes.text = String(likes.count)
                }
                else {
                    self.numLikes.text = "0"
                }
            })
        }
    }
    
    func downloadPic() {
        if profURL == "" {
            return
        }
        
        let surl = URL(string: profURL!)
        let url = URLRequest(url: surl!)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error as? String)
                return
            }
            
            DispatchQueue.main.async {
                self.profilePic.image = UIImage(data: data!)
            }
        }.resume()
        
        self.profilePic.contentMode = .scaleToFill
        self.profilePic.layer.backgroundColor = UIColor.white.withAlphaComponent(0.40).cgColor
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        self.profilePic.clipsToBounds = true
        self.profilePic.isHidden = false
    }
    
    @IBAction func like(_ sender: Any) {
        if !liked {
            if !isPublic! {
                self.ref?.child("Events").child(parentView!.eid!).child("comments").child(self.commentID!).child("likes").child(SignUp1.User.uid).setValue("like")
            }
            else {
                self.ref?.child("Public Events").child(self.eventType!).child(parentView!.eid!).child("comments").child(self.commentID!).child("likes").child(SignUp1.User.uid).setValue("like")

            }
            self.liked = true
            self.numLikes.text = String(Int(self.numLikes.text!)! + 1)
            self.likeButton.tintColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
        }
        else {
            if !isPublic! {
                self.ref?.child("Events").child(parentView!.eid!).child("comments").child(self.commentID!).child("likes").child(SignUp1.User.uid).removeValue()
            }
            else {
                self.ref?.child("Public Events").child(self.eventType!).child(parentView!.eid!).child("comments").child(self.commentID!).child("likes").child(SignUp1.User.uid).setValue("like")
            }
            self.liked = false
            self.numLikes.text = String(Int(self.numLikes.text!)! - 1)
            self.likeButton.tintColor = UIColor.lightGray
        }
        
    }
    
    
}
