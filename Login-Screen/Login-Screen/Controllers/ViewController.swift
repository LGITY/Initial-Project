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
    
    //for the descriptions
    var postData = [String]()
    
    //for the image names
    var imageData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up Table View Controller
        tableView.delegate = self
        tableView.dataSource = self
        
        //Creates the nib for the table view to reference
        let nibName = UINib(nibName: "PostCell", bundle: nil)
        
        //registers the nib for use with the table view
        tableView.register(nibName, forCellReuseIdentifier: "PostCell")
        
        //Set firebase database reference
        ref = Database.database().reference()
        
        //Retrieve the data to populate the cells from Firebase and listen for changes
        ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            
            
            //Code to execute when a child is added in "Posts"
            
            //Take the value from the snapshot and add it to the post data array at the top of this class
            
            //set post to just be the value of the snapshot (post data); attempts to assign the value to a String if not null
            let post = snapshot.value as? [String: AnyObject]
            
            //testing to make sure there is data in post
            if let actualPost = post {
                let apa = actualPost["Activity"] as! String
                let apd = actualPost["Description"] as! String
                //appends the post to the end of our post data array
                self.postData.append(apd)
                self.imageData.append(apa)
                
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
        
        //dequeus the cell that we created and styled in the xib file for reuse
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        //this constructs the cell based on the parameters of the specific post's data
        cell.commonInit(imageData[indexPath.item], description: postData[indexPath.item])
        return cell
    }
    
    //returns the height of the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }


}

