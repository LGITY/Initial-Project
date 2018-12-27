//
//  CommentsView.swift
//  Login-Screen
//
//  Created by Davis Booth on 12/25/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import Firebase

class CommentsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var eid: String?
    var ref: DatabaseReference?
    
    var commentList: [String: [String:Any]] = [:]
    
    var commentKeys : [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: "CommentsCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "commentsCell")
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        ref = Database.database().reference()
        
        fetchComments()
        
    }
    
    func fetchComments() {
        ref?.child("Events").child(eid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! [String : Any]
            if value.keys.contains("comments") {
                let unsorted = value["comments"] as! [String: [String:Any]]
                self.commentList = unsorted
                let keys = Array(unsorted.keys)
                let sorted = keys.sorted(by: { (key1, key2) -> Bool in
                    let val1 = self.commentList[key1]!["time"] as! String
                    let val2 = self.commentList[key2]!["time"] as! String
                    return val1 < val2
                })
                self.commentKeys = sorted
                
            }
        })
    }
    
    @IBAction func sendButton(_ sender: Any) {
        if textField.text != "" {
            var infoDict: [String : String] = [:]
            infoDict["userID"] = SignUp1.User.uid
            infoDict["text"] = textField.text!
            infoDict["time"] = String(NSDate().timeIntervalSince1970)
            //infoDict["likes"] = "0"
            ref?.child("Events").child(eid!).child("comments").childByAutoId().setValue(infoDict)
        }
        fetchComments()
        textField.text = ""
    }
    
    
    
}

extension CommentsView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("COUNT::")
        return commentList.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsCell
        let thisKey = commentKeys[indexPath.item]
        let uid = commentList[thisKey]!["userID"] as! String
        let comment = commentList[thisKey]!["text"] as! String
        let time = commentList[thisKey]!["time"] as! String
        var numLikes = 0
        if commentList[thisKey]!.keys.contains("likes") {
            numLikes = (commentList[thisKey]!["likes"] as! [String : String]).count
        }
        
        cell.fullInit(uid, commentID: thisKey, comment: comment, time: time, likes: String(numLikes), parent: self)
        print("HERE!!")
        return cell
    }
}
