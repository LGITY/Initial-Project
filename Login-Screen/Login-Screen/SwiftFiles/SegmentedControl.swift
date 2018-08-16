//
//  SegmentedControl.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/16/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

@IBDesignable class SegmentedControl: UIControl {
    
    //variable for the labels of the segmented control
    private var labels = [UILabel]()
    
    //variable for the overarching view in which the labels are stored
    var thumbView = UIView()
    
    //sets up the labels to be populated into the labels array and displayed in the thumbview
    var items: [String] = ["friends", "interests", "groups"] {
        didSet {
            setupLabels()
        }
    }
    
    //consistently sets up the selected index to be different than the others
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    var parentView: profile
    
    //required initializer for this class -- call our general set up method
    override init(frame: CGRect) {
        //set up before the init method so that the init method thinks that it is setting up the parent view, but we're really just shamboozling it
        self.parentView = profile()
        
        super.init(frame: frame)
        //self.parentView = profile()
        setUpThumbView()
    }
    
    //required initializer for this class -- call our general set up method
    required init?(coder: NSCoder) {
        //set up before the init method so that the init method thinks that it is setting up the parent view, but we're really just shamboozling it
        self.parentView = profile()
        
        super.init(coder: coder)
        setUpThumbView()
    }
    
    func fullInit(view: profile) {
        parentView = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectedFrame = self.bounds
        let newWidth = selectedFrame.width/CGFloat(items.count)
        selectedFrame.size.width = newWidth
        thumbView.frame = selectedFrame
        thumbView.backgroundColor = UIColor.clear
        //thumbView.layer.cornerRadius = thumbView.frame.height/2
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red:0.03, green:1.00, blue:0.52, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: thumbView.frame.size.height - width-2, width: thumbView.frame.size.width, height: thumbView.frame.size.height)
        
        border.borderWidth = CGFloat(4.0)
        //border.cornerRadius = 10
        thumbView.layer.addSublayer(border)
        thumbView.layer.masksToBounds = true
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        
        for index in 0...labels.count-1 {
            var label = labels[index]
            
            let xPos =  CGFloat(index) * labelWidth
            label.frame = CGRect(origin: CGPoint(x: xPos,y :0), size: CGSize(width: labelWidth, height: labelHeight))
            
        }
        
        
        
    }
    
    //really interesting function that tracks location of touch and reacts accordingly
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        //gets the location of the user's touch point
        let location = touch.location(in: self)
        
        //this will be eventually set to whichever label's index was clicked
        var calculatedIndex : Int?
        
        //loops through all of the labels -- gets their index in the array as well as the full item
        for (index, item) in labels.enumerated() {
            //if the location that the user tapped is contained within the frame of the label
            if item.frame.contains(location) {
                //then the calculated index is the index of that label in the labels array
                calculatedIndex = index
            }
        }
        
        //if a touch was determined to be inside of the segmented control
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
        
    }
    
    //set up the overrall view style and stuff by calling other methods too
    func setUpThumbView() {
        
        //designs the overarching view for the segmented control
        //layer.cornerRadius = frame.height/2
        //layer.borderColor = UIColor.black.cgColor
        //layer.borderWidth = 2
        layer.backgroundColor = UIColor.clear.cgColor
        
        setupLabels()
        
        insertSubview(thumbView, at: 0)
        
        
    }
    
    func displayNewSelectedIndex() {
        var label = labels[selectedIndex]
        UIView.animate(withDuration: 0.2, animations: {
            self.thumbView.frame = label.frame
        }) { (completed) in
            return
        }
        self.thumbView.frame = label.frame
        
        //goes back to the view controller and changes the content displayed
        changeContent(view: parentView)
    }
    
    func displayNewSelectedIndexSwipeLeft(left: Bool, view: profile) {
        if left {
            if selectedIndex+1 < 3 {
                selectedIndex += 1
            }
        }
        else {
            if selectedIndex-1 > -1 {
                selectedIndex -= 1
            }
        }
    }
    
    func changeContent(view: profile) {
        switch selectedIndex {
        case 0:
            view.updateScroll(xVal: 0, yVal: 0)
        case 1:
            view.updateScroll(xVal: 375, yVal: 0)
        case 2:
            view.updateScroll(xVal: 750, yVal: 0)
        default:
            print("blah")
        }
    }
    
    
    //sets up the labels appropriately (I don't understand this one as much as the others)
    func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            let label = UILabel(frame: CGRect.zero)
            label.text = items[index-1]
            label.textAlignment = .center
            label.textColor = UIColor.lightGray
            self.addSubview(label)
            labels.append(label)
        }
    }
}
