//
//  MoreTab.swift
//  Login-Screen
//
//  Created by Davis Booth on 1/7/19.
//  Copyright © 2019 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class MoreTab: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        profPic.layer.cornerRadius = profPic.frame.height/2
        profPic.clipsToBounds = true
        profPic.contentMode = .scaleAspectFill
        ref = Database.database().reference()
        ref?.child("Users").child(SignUp1.User.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! [String: Any]
            self.name.text = (value["first"] as! String) + " " + (value["last"] as! String)
            self.username.text = value["username"] as! String
            let urlPath = value["prof-pic"] as? String
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
    
}

// Table view stuff.
extension MoreTab {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(frame: CGRect.zero)
    }
}
