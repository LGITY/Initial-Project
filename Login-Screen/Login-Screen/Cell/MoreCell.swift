//
//  MoreCell.swift
//  Login-Screen
//
//  Created by Davis Booth on 12/26/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MoreCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    var parentView: HomePostCell?
    var ref: DatabaseReference?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
    }
    
    func fullInit(_ action: String, parent : HomePostCell) {
        button.setTitle(action, for: .normal)
        self.parentView = parent
    }
    
    @IBAction func button(_ sender: Any) {
        if button.titleLabel!.text! == "Delete Post" {
            ref?.child("Events").child(parentView!.eid).child("availableTo").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! [String]
                for user in value {
                    self.ref?.child("Users").child(user).child("Events").child(self.parentView!.eid).removeValue()
                }
                self.ref?.child("Users").child(SignUp1.User.uid).child("Events").child(self.parentView!.eid).removeValue()
                self.ref?.child("Events").child(self.parentView!.eid).removeValue()
            })
            
            parentView?.moreTable.isHidden = true
            parentView?.parentViewController!.mainTableView.reloadData()
        }
        else {
            print("edit!")
            parentView?.moreTable.isHidden = true
            parentView?.parentViewController!.viewDidLoad()
            parentView?.parentViewController!.mainTableView.reloadData()
        }
    }
}
