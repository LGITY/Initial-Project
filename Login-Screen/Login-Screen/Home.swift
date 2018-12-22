//
//  Home.swift
//  Login-Screen
//
//  Created by Davis Booth on 11/24/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var mainTableView: UITableView!
    
    var userInfo : User!
    
    var availablePosts: [String: Any] = [:] {
        didSet {
            mainTableView.reloadData()
            availablePostKeys = Array(availablePosts.keys.sorted())
        }
    }
    
    var availablePostKeys: [String] = [String]() {
        didSet {
            mainTableView.reloadData()
            print(availablePostKeys)
        }
    }
    
    
    var ref: DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        //Creates the nib for the table view to reference
        let nibName = UINib(nibName: "HomePostCell", bundle: nil)
        
        //registers the nib for use with the table view
        mainTableView.register(nibName, forCellReuseIdentifier: "HomePostCell")
        
        //disables scrollbar in both directions
        mainTableView.showsHorizontalScrollIndicator = false
        mainTableView.showsVerticalScrollIndicator = false
        
        
        let tabbar = tabBarController as! tabBarController
        userInfo = tabbar.userInfo

        // observes the available events and populates properly to the available posts array which is then reloaded.
        ref = Database.database().reference()
        ref?.child("Users").child(userInfo.id).child("Events").observeSingleEvent(of: .value, with: { (snapshot) in
        // Get user value
    
            let value = snapshot.value as? [String: Any]

            print(value)
            self.availablePosts = value as? [String:Any] ?? [:]
            //((snapshot.value as! [Any])[8] as! String, (snapshot.value as! [Any])[8] as! String) )
//            thing.sorted(by: { ((key: String, value: Any)
//                , (key: String, value: Any)
//                ) -> Bool in
//
//            })
            //thing = thing.sorted(by: {(($0.1 as! [String: String])["time"] as! String) < (($1.1 as! [String: String])["time"] as! String)} )
            //self.availablePosts = thing
        })
        

    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "In My Area"
//        }
//        else {
//            return "From My Friends"
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        }
//        else {
            return availablePostKeys.count
  //      }
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 401
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //if indexPath.item == 0 {return UITableViewCell()}
        //else {
            let cell = mainTableView.dequeueReusableCell(withIdentifier: "HomePostCell", for: indexPath) as! HomePostCell
            
            let eid = availablePostKeys[indexPath.item]
            print(availablePosts[eid] as! [String: Any])
            
            // This basically just requires a lot of different typing. Primarily because we are indexing the event, and then inside of the event we need many values. So by indexing the event, we get back a dictionary of Strings (the event id's) to dictionaries (all of the components of the event). From here, we need to convert the value of the eventID to a dictionary of a bunch of strings to a bunch of other things. Then, when we get back the objects of the keys of the dictionary, we need to convert them to their proper value.
        cell.fullInit((availablePosts[eid] as! [String: Any])["host"] as! String , evID: eid, activity: (availablePosts[eid] as! [String: Any])["eventType"] as! String, eventName: (availablePosts[eid] as! [String: Any])["eventName"] as! String, numberParticipants: Int((availablePosts[eid] as! [String: Any])["numParticipants"] as! String)!, time: (availablePosts[eid] as! [String: Any])["time"] as! String, loc: (availablePosts[eid] as! [String: Any])["locationName"] as! String)
            
            return cell
        //}
    }
    
    

}
