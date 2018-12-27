//
//  SignUp3.swift
//  Login-Screen
//
//  Created by Davis Booth on 7/27/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUp3: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    

    @IBOutlet weak var headerLabel: UILabel!
    
    //background outlets
    @IBOutlet weak var backgroundPic: UIImageView!
    @IBOutlet weak var backgroundColor: UIView!
    
    //activity view outlets
    @IBOutlet weak var activityView: UIView!
    
    
    //dot outlets
    @IBOutlet weak var dotStack: UIStackView!
    @IBOutlet weak var dotFirst: UIView!
    @IBOutlet weak var dotSecond: UIView!
    @IBOutlet weak var dotThird: UIView!
    @IBOutlet weak var dotFourth: UIView!
    @IBOutlet weak var dotLast: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    var activities: [String] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    var availableActivities: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var ref: DatabaseReference?
    
    //dictionary that carries information from page to page
    var info: NSMutableDictionary = [:]
    
    override func viewDidLoad() {
        print("signUp3 info: ", info)
        super.viewDidLoad()
        
        // Set up collection view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //loads background
        loadBackground()
        
        //load navigation bar
        loadNavigationBar()

        //loads header label
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.white

        
        //loads activity view
        activityView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        activityView.layer.cornerRadius = 10


        //loads dots
        loadDots()

        //loads next button
        nextButton.layer.cornerRadius = 15
        
        ref = Database.database().reference()
        
        ref?.child("Activities").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! [String: String]
            var tempArr: [String] = []
            for val in value {
                tempArr.append(val.value)
            }
            self.availableActivities = tempArr
        })
        
    }
    
    
    func loadNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func loadBackground() {
        //BACKGROUND
        //Sets up the background layer; creates a background rectangle, shades it in, and then adds the image in the background to fill the whole thing
        //let layer = UIView(frame: CGRect(x: -967, y: -214, width: 2337, height: 1547))
        backgroundColor.backgroundColor = UIColor(red:0.03, green:0.12, blue:0.18, alpha:0.7)
        //self.view.addSubview(layer)
        backgroundPic.image = #imageLiteral(resourceName: "sign-up-background")
        backgroundPic.contentMode = .scaleAspectFill
    }
    
    func loadDots() {
        
        //add green dot
        dotThird.backgroundColor = UIColor(red:0.03, green:1, blue:0.52, alpha:1)
        dotThird.layer.cornerRadius = dotFirst.frame.size.width/2
        
        //adds grey dots
        let dotArray = [dotFirst, dotSecond, dotFourth, dotLast] as! [UIView]
        for dot in dotArray {
            dot.backgroundColor = UIColor.lightGray
            dot.layer.cornerRadius = dot.frame.size.width/2
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? SignUp4 {
            for (key, value) in info {
                destinationController.info[key] = value
            }
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        
        info["activities"] = activities
        print("chach")
        
        self.performSegue(withIdentifier: "toSignUp4", sender: self)
    }
}

extension SignUp3 {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableActivities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath as IndexPath) as! SignUpActivityCell
        cell.fullInit(availableActivities[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SignUpActivityCell
        appendOrRemove(cell)
        print("!! RECOGNIZED !!")
        
    }
    
    func appendOrRemove(_ cell: SignUpActivityCell) {
        if activities.contains(cell.activity!) {
            activities.removeAll(where: { $0 == cell.activity!})
            cell.image.tintColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
            cell.label.textColor = UIColor(red:0.11, green:0.17, blue:0.27, alpha:1.0)
            print(cell.activity! + " REMOVED")
        }
        else {
            activities.append(cell.activity!)
            cell.image.tintColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
            cell.label.textColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
            print(cell.activity! + " ADDED")
        }
    }
}
