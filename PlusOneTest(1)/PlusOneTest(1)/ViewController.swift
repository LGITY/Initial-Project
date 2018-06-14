//
//  ViewController.swift
//  PlusOneTest(1)
//
//  Created by Davis Booth on 6/14/18.
//  Copyright © 2018 Davis Booth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let layer = UIView(frame: CGRect(x: -14, y: -12, width: 1103, height: 1947))
        layer.alpha = 0.55
        layer.backgroundColor = UIColor.black
        self.view.addSubview(layer)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

