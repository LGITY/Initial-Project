//
//  CreateEvent1.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/30/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class CreateEvent1: UIViewController {
    @IBOutlet weak var verticalStack: UIStackView!
    @IBOutlet weak var horizontalStack1: UIStackView!
    @IBOutlet weak var horizontalStack2: UIStackView!
    @IBOutlet weak var horizontalStack3: UIStackView!
    @IBOutlet weak var horizontalStack4: UIStackView!
    @IBOutlet weak var horizontalStack5: UIStackView!
    
    var stackArray: [UIStackView]?
    
    var activityList: [String] = [String]() {
        didSet {
            loadMembers()
        }
    }
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        stackArray = [horizontalStack1, horizontalStack2, horizontalStack3, horizontalStack4,horizontalStack5]
        
        ref?.child("Activities").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var tList = [String]()
            for key in (value?.allKeys)! {
                tList.append((value![key] as? String ?? ""))
            }
            self.activityList = tList
        })
        
        // Do any additional setup after loading the view.
    }
    
    func loadMembers() {
        var i = 0
        var j = 0
        
        for member in self.activityList {
            var currentStack = stackArray![j] as? UIStackView ?? UIStackView()
            if i < 5 {
                //var pic: String?
                //ref?.child("Users").child(member).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    //let value = snapshot.value as? NSDictionary
                    //let link = value?["prof-pic"] as? String ?? ""
//                    let name = (value?["first"] as! String) + " " + (value?["last"] as! String)
//                    pic = link
//                    let urlPath = pic
//                    if let profUrl = urlPath {
//                        let surl = URL(string: profUrl)
//                        let url = URLRequest(url: surl!)
//                        URLSession.shared.dataTask(with: url) { (data, response, error) in
//                            if error != nil {
//                                print(error as! String)
//                                return
//                            }
//
//                            DispatchQueue.main.async {
//                                let image = UIImage(data: data!)
                                  let image = #imageLiteral(resourceName: "sports")
                                  let imageView = UIImageView(image: image)
//                                let view = UIView()
//                                //view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//                                view.addSubview(imageView)
//                                //view.contentMode =
//                                //setup image view
                                  imageView.clipsToBounds = true
//                                  imageView.sizeToFill()
                                  imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                                  imageView.contentMode = .scaleAspectFill
                                  imageView.clipsToBounds = true
//                                //imageView.widthAnchor.constraint(equalTo: .width, multiplier: 0.1)
//
//                                //let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: imageView.frame.width, height: 20))
                                let lbl = UILabel()
                                //lbl.sizeToFit()
                                lbl.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
                                lbl.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
                                lbl.text =  member      //self.activityList[i + 5*j]
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
                let gest = UITapGestureRecognizer(target: stack, action: #selector(self.tapBlurButton(_:)),
                                stack.addGestureRecognizer(
                                currentStack.distribution = .fillEqually
                                currentStack.addArrangedSubview(stack)
                            //}
                            
                            //}.resume()
                i += 1
            }
                
                //})
            //}
            else {
                j += 1
                i = 0
            }
        }
        //self.verticalStack.translatesAutoresizingMaskIntoConstraints = false
        //self.verticalStack.distribution = .fillEqually
        //self.verticalStack.spacing = 4
        //self.verticalStack.
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
