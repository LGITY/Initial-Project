//
//  GroupCell.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/30/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var verticalStack: UIStackView!
    
    var members: [String] = [String]()
    var name = ""
    var gid = ""
    var inited = false
    
    var ref: DatabaseReference?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ref = Database.database().reference()
    }
    
    func commonInit(_ id: String, name: String, members: [String]) {
        gid = id
        self.name = name
        let tName = name.capitalized
        label.text = tName
        label.textColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
        self.members = members
        self.selectionStyle = UITableViewCellSelectionStyle.none
        if !inited {
            configMembers()
        }
        inited = true
    }
    
    func configMembers() {
        var i = 0
        var tooMany = false
        for member in self.members {
            if i < 5 {
                var pic: String?
                ref?.child("Users").child(member).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let link = value?["prof-pic"] as? String
                    let name = (value?["first"] as? String ?? "") + " " + (value?["last"] as? String ?? "")
                    //let name = "Fernando"
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
                                
                                
                                //stack.alignment = .center
                                //stack.semanticContentAttribute = .forceLeftToRight
                                
                                self.verticalStack.addArrangedSubview(stack)
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
        self.verticalStack.translatesAutoresizingMaskIntoConstraints = false
        self.verticalStack.distribution = .fillEqually
        self.verticalStack.spacing = 4
        //self.verticalStack.
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
