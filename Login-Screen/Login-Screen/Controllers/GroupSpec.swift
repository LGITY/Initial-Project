//
//  GroupSpec.swift
//  Login-Screen
//
//  Created by Davis Booth on 9/1/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class GroupSpec: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    
    static var gid: String?
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var memberStatus: UIStackView!
    @IBOutlet weak var numMembers: UILabel!
    @IBOutlet weak var numEvents: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var memberStack: UIStackView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imageOverlay: UIView!
    
    var ref: DatabaseReference?
    
    var memberList: [String]? {
        didSet {
            loadMembers()
        }
    }
    var eventList: [String]?
    
    public var User: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load navigation bar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        imageOverlay.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        //initially hide membership confirmation status until the user is determined to be in the group
        memberStatus.isHidden = true
        
        //setup Group name, number of members, number of events, profile picture, and description
        ref = Database.database().reference()
        ref?.child("Groups").child(GroupSpec.gid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let gName = value?["name"] as? String ?? ""
            let gDescription = value?["description"] as? String ?? ""
            let gPic = value?["group-pic"] as? String
            let gMembers = value?["members"] as? [String] ?? [String]()
            let gEvents = value?["events"] as? [String] ?? [String]()
            
            //setup the easy ones: group name and group description
            self.groupName.text = gName
            self.descriptionText.text = gDescription
            self.memberList = gMembers
            self.eventList = gEvents
            self.numMembers.text = String(gMembers.count) + " MEMBERS"
            self.numEvents.text = String(gEvents.count) + " EVENTS"
            
            if let profUrl = gPic {
                let surl = URL(string: profUrl)
                let url = URLRequest(url: surl!)
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error as! String)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.groupImage.image = UIImage(data: data!)
                    }
                    
                    }.resume()
            }
            
            if self.memberList!.contains(self.User.uid) {
                self.memberStatus.isHidden = false
            }

            

        })
        groupImage.contentMode = .scaleAspectFill
        groupImage.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    func loadMembers() {
        var i = 0
        var tooMany = false
        for member in self.memberList! {
            if i < 5 {
                var pic: String?
                ref?.child("Users").child(member).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let link = value?["prof-pic"] as? String ?? ""
                    let name = (value?["first"] as! String) + " " + (value?["last"] as! String)
                    pic = link
                    let urlPath = pic
                    if let profUrl = urlPath {
                        let surl = URL(string: profUrl)
                        let url = URLRequest(url: surl!)
                        URLSession.shared.dataTask(with: url) { (data, response, error) in
                            if error != nil {
                                print(error as! String)
                                return
                            }
                            
                            DispatchQueue.main.async {
                                let image = UIImage(data: data!)
                                let imageView = UIImageView(image: image)
                                let view = UIView()
                                //view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                                view.addSubview(imageView)
                                //view.contentMode =
                                //setup image view
                                //imageView.clipsToBounds = true
                                //imageView.sizeToFill()
                                //imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                                imageView.contentMode = .scaleAspectFill
                                imageView.clipsToBounds = true
                                //imageView.widthAnchor.constraint(equalTo: .width, multiplier: 0.1)
                                
                                //let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: imageView.frame.width, height: 20))
                                let lbl = UILabel()
                                //lbl.sizeToFit()
                                lbl.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
                                lbl.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
                                lbl.text = name
                                lbl.lineBreakMode = .byTruncatingTail
                                lbl.font = UIFont(name: "Futura-Medium", size: 10.0)
                                lbl.textColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
                                
                                
                                //view.clipsToBounds = true
                                //let c1 = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
                                //let c2 = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
                                let c3 = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30)
                                let c4 = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30)
                                //view.addConstraint(c1)
                                //view.addConstraint(c2)
                                
                                let stack = UIStackView()
                                
                                stack.addArrangedSubview(imageView)
                                stack.addArrangedSubview(lbl)
                                stack.addConstraint(c3)
                                stack.addConstraint(c4)
                                imageView.layer.cornerRadius =  15
                                stack.axis = .vertical
                                stack.spacing = 1
                                stack.clipsToBounds = true
                                stack.alignment = .center
                                stack.distribution = .fillEqually
                                stack.contentMode = .left
                                
                                                            
                                self.memberStack.addArrangedSubview(stack)
                            }
                            
                            }.resume()
                    }
                    i += 1
                })
            }
            else {
                tooMany = true
                break
            }
        }
        self.memberStack.translatesAutoresizingMaskIntoConstraints = false
        self.memberStack.distribution = .fillEqually
        self.memberStack.spacing = 4
        //self.verticalStack.
    }
    
    
    //need to implement way to get back to the groups tab of the profile as opposed to the friends tab -- ass
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToProfile", sender: self)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
