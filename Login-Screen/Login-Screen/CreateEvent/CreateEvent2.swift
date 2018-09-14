//
//  CreateEvent2.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/30/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class CreateEvent2: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var friendsImage: UIImageView!
    @IBOutlet weak var invitesView: UIView!
    @IBOutlet weak var segmentedControl: SegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pickerDataSource = ["Private", "Friends of Friends", "Nearby Players"]
    
    var pickerChoice: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        invitesView.isHidden = true
        pickerView.selectRow(1, inComponent: 0, animated: false)
        (pickerView.view(forRow: 1, forComponent: 0) as! UILabel).textColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
        // Do any additional setup after loading the view.
        
        //load segmented control
        //passes in a pointer to this view controller that allows for manipulation of it
        segmentedControl.fullInit(view: self, options: ["Friends", "Groups"])
        
        //allows for the gesture recognition of the swipe left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(CreateEvent2.respondToSwipeGesture(sender:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        //allows for the gesture recognition of the swipe right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(CreateEvent2.respondToSwipeGesture(sender:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func respondToSwipeGesture(sender: UIGestureRecognizer) {
        if let swiped = sender as? UISwipeGestureRecognizer {
            switch swiped.direction {
            case UISwipeGestureRecognizerDirection.left:
                print("GO LEFT GO LEFT")
                segmentedControl.displayNewSelectedIndexSwipeLeft(left: true, view: self)
            case UISwipeGestureRecognizerDirection.right:
                print("Right babe")
                segmentedControl.displayNewSelectedIndexSwipeLeft(left: false, view: self)
            default:
                break
            }
        }
        //segmentedControl.displayNewSelectedInde
    }
    
    func updateScroll(xVal: Int, yVal: Int) {
        scrollView.setContentOffset(CGPoint(x: xVal, y: yVal), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //returns how many columns there are in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //returns how many rows there are in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    //returns each piece of data to be inserted in the row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    //function runs every time the picker is changed to have a different choice selected; sets the global variable pickerChoice to the current choice
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        (pickerView.view(forRow: row, forComponent: component) as! UILabel).textColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
        let choice = pickerDataSource[row]
        pickerChoice = choice
        self.invitesView.isHidden = true
        if choice == "Private" {
            self.friendsImage.image = #imageLiteral(resourceName: "RingsShareevent")
            self.invitesView.isHidden = false
        }
        else if choice == "Friends of Friends" {self.friendsImage.image = #imageLiteral(resourceName: "RingsshareEventfriends")}
        else {self.friendsImage.image = #imageLiteral(resourceName: "ringsshareeventGlobal")}
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Futura-Medium", size: 10)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.pickerDataSource[row]
        //pickerLabel?.textColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
        pickerLabel?.textColor = UIColor.lightGray
        return pickerLabel!
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
