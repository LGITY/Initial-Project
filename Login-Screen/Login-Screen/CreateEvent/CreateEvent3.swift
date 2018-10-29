//
//  CreateEvent3.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/30/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class CreateEvent3: UIViewController {
    var currentCircleSlider: CircleSlider!
    
    @IBOutlet weak var desc: UILabel!
    //@IBOutlet weak var scrollView: UIScrollView!
    static var text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let circleSlider = CircleSlider(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: self.view.frame.width))
        circleSlider.makeSlider()
        CreateEvent3.text = UILabel(frame: CGRect(x: view.center.x, y: view.center.y, width: circleSlider.circle_diameter, height: circleSlider.circle_diameter))
        CreateEvent3.text.textAlignment = .center
        CreateEvent3.text.center = CGPoint(x: view.center.x, y: circleSlider.center.y)
        CreateEvent3.text.text = "∞"
        CreateEvent3.text.font = UIFont(name: "Futura-Medium", size: 140)
        CreateEvent3.text.textColor = UIColor(red:0.13, green:0.70, blue:1.00, alpha:1.0)
        self.view.addSubview(CreateEvent3.text)
        currentCircleSlider = circleSlider
        self.view.addSubview(circleSlider)
        let verticalSpace = NSLayoutConstraint(item: circleSlider, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: desc, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 10)
        NSLayoutConstraint.activate([verticalSpace])
        //scrollView.isScrollEnabled = false
        //scrollView.bouncesZoom = false
        //scrollView.showsVerticalScrollIndicator = false
        //scrollView.showsHorizontalScrollIndicator = false
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        CreateEvent1.Event.eventInfo["numParticipants"] = CreateEvent3.text.text as? String ?? "∞"
        self.performSegue(withIdentifier: "toCE4" , sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
