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
import CoreLocation

class CreateEvent1: UIViewController {
    @IBOutlet weak var verticalStack: UIStackView!
    @IBOutlet weak var horizontalStack1: UIStackView!
    @IBOutlet weak var horizontalStack2: UIStackView!
    @IBOutlet weak var horizontalStack3: UIStackView!
    @IBOutlet weak var horizontalStack4: UIStackView!
    @IBOutlet weak var horizontalStack5: UIStackView!
    
    @IBOutlet weak var textField: UITextField!
//    let user = Sign
    //location object
    let manager = CLLocationManager()
    
    var stackArray: [UIStackView]?
    
    //list of members???
    var activityList: [String] = [String]() {
        didSet {
            loadMembers()
        }
    }
    
    var selectedActivity: String?
    
    
    var ref: DatabaseReference?
    
    var stackDict = [UIGestureRecognizer: UIImageView]()
    
    var currentSelection: UIGestureRecognizer?
    var pastSelection: UIGestureRecognizer?
    var selection: String?
    
    
    struct Event {
        
        static var eventInfo: NSMutableDictionary = [:]
        
        //populated by CreateEvent1
        static var eventName: String?
        static var eventType: UIImage?
        
        //populated by CreateEvent2
        static var availableTo: [String]?
        static var privacyType: String?
        
        //populated by CreateEvent3
        static var numParticipants: String?
        
        //populated by CreateEvent4
        static var time: Date?
        static var place: CLLocationCoordinate2D?
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self as? CLLocationManagerDelegate
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.distanceFilter = kCLDistanceFilterNone
        print("longitude: ",manager.location?.coordinate.longitude)
        print("latitude: ",manager.location?.coordinate.latitude)
        print("howdyhooooooooohohooh")
        ref = Database.database().reference()
        
        loadMembers()
        
        stackArray = [horizontalStack1, horizontalStack2, horizontalStack3, horizontalStack4,horizontalStack5]
        
        //getting list of activities from firebase
        ref?.child("Activities").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var tList = [String]()
            for key in (value?.allKeys)! {
                tList.append((value![key] as? String ?? ""))
            }
            self.activityList = tList
        })
        print("user_id: ",SignUp1.User.uid)
       //
    self.ref?.child("Users").child((SignUp1.User.uid)).child("location").setValue((manager.location?.coordinate.latitude))
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.resignFirstResponder()
    }
    
    
    func loadMembers() {
        var i = 0
        var j = 0
        
        for member in self.activityList {
            if(i==3)
            {
                i=0
                j+=1
            }
            i += 1
            var currentStack = stackArray![j] as? UIStackView ?? UIStackView()
            //why does i have to be less than 5???
            
              
                                  let storage = Storage.storage().reference().child("Activity Pictures").child(member + ".png")
                
                
                                    var image : UIImage? = UIImage()
                                    print(storage)
                                    storage.downloadURL(completion: { (url, error) in
                                        
                                        if error != nil {
                                            print("ERROR COULD NOT DOWNLOAD ACTIVITY IMAGE")
                                            return
                                        }
                                        
                                      
                                            
                                        
                                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                            
                                            if error != nil {
                                                print("ERROR COULD NOT DOWNLOAD FROM URL")
                                                return
                                            }
                                            
                                            guard let imageData = UIImage(data: data! as Data) else { return }
                                            
                                            print("IMAGEDATA")
                                            print(imageData)
                                            
                                            DispatchQueue.main.async {
                                                image = imageData
                                                let imageView = UIImageView(image: image)
                                                
                                                imageView.clipsToBounds = true
                                                imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                                                imageView.contentMode = .scaleToFill
                                                imageView.clipsToBounds = false
                                                
                                                imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
                                                imageView.tintColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
                                                //theImageView.tintColor = UIColor.red
                                                let lbl = UILabel()
                                                //lbl.sizeToFit()
                                                lbl.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
                                                lbl.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
                                                lbl.text =  member      //self.activityList[i + 5*j]
                                                lbl.lineBreakMode = .byTruncatingTail
                                                lbl.font = UIFont(name: "Futura-Medium", size: 10.0)
                                                lbl.textColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
                                                
                                                
                                                let c3 = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
                                                let c4 = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 50)
                                                
                                                let stack = UIStackView()
                                                
                                                stack.addArrangedSubview(imageView)
                                                stack.addArrangedSubview(lbl)
                                                stack.addConstraint(c3)
                                                stack.addConstraint(c4)
   //                                             imageView.layer.cornerRadius =  15
                                                stack.axis = .vertical
                                                stack.spacing = 1
                                                stack.clipsToBounds = true
                                                stack.alignment = .center
                                                stack.distribution = .fillEqually
                                                stack.contentMode = .left
                                                let gest = UITapGestureRecognizer(target: self, action: #selector(self.tappedButton(_:)))
                                                //adding gesture as key, image as element
                                                self.stackDict[gest] = imageView
                                                //adding gesture to this vertical stack
                                                stack.addGestureRecognizer(gest)
                                                currentStack.distribution = .fillEqually
                                                currentStack.addArrangedSubview(stack)
                                                
                                                self.verticalStack.distribution = .fill
                                                let c5 = NSLayoutConstraint(item: currentStack, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
                                                self.verticalStack.addConstraint(c5)
                                            }
                                        }).resume()
                                        
                                        
                                    })

            
        }

    }
    

    @objc func tappedButton(_ sender : Any) {
        //self.selectedActivity =
        print("yoyoyo")
        if self.currentSelection != nil {
            self.stackDict[self.currentSelection!]?.tintColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
            
            //self.stackDict[self.currentSelection!]?.image = #imageLiteral(resourceName: "sports")
            self.pastSelection = self.currentSelection!
        }
        self.currentSelection = (sender as! UIGestureRecognizer)
        let thing = (self.stackDict[self.currentSelection!]?.superview as! UIStackView).arrangedSubviews
        selection = (thing[thing.count-1] as! UILabel).text
        print("bitch! \(selection)")
        self.stackDict[(sender as! UIGestureRecognizer)]?.tintColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
        //self.stackDict[(sender as! UIGestureRecognizer)]?.image = #imageLiteral(resourceName: "ball-of-basketball (3)")

    }
    
    @IBAction func nextButton(_ sender: Any) {
        CreateEvent1.Event.eventInfo["eventName"] = self.textField.text
        //CreateEvent1.Event.eventInfo["eventType"] = self.stackDict[self.currentSelection!]?.image
        CreateEvent1.Event.eventInfo["eventType"] = selection!
        self.performSegue(withIdentifier: "next", sender: self)
    }
    
    //func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //CreateEvent1.Event.eventName = textField.text
      //  CreateEvent1.Event.eventType =
    //}
    
    
    
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



extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
