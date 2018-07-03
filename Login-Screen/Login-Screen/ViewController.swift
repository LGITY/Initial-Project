//
//  ViewController.swift
//  Login-Screen
//
//  Created by Brad Levin on 6/14/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //Reference that links up the database
    var ref: DatabaseReference!
    
    //Database Handle that specifies the listener connection
    var databaseHandle: DatabaseHandle?
    
    var postData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up Table View Controller
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set firebase database reference
        ref = Database.database().reference()
        
        //Retrieve the data to populate the cells from Firebase and listen for changes
        ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            
            
            //Code to execute when a child is added in "Posts"
            //Take the value from the snapshot and add it to the post data array at the top of this class
            
            //set post to just be the value of the snapshot (post data); attempts to assign the value to a String if not null
            let post = snapshot.value as? String
            
            //testing to make sure there is data in post
            if let actualPost = post {
                //appends the post to the end of our post data array
                self.postData.append(actualPost)
                
                //reloads table to refresh data
                self.tableView.reloadData()
            }
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        cell?.textLabel?.text = postData[indexPath.row]
        return cell!
    }


}

