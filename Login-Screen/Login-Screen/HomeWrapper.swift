//
//  HomeWrapper.swift
//  Login-Screen
//
//  Created by Davis Booth on 1/7/19.
//  Copyright © 2019 Brad Levin. All rights reserved.
//

import UIKit

class HomeWrapper: UIViewController {
    
    @IBOutlet weak var moreTabXPos: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    var tabBarVisible: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu(_:)), name: NSNotification.Name("ToggleMoreTab"), object: nil)
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //mainView.addGestureRecognizer(tap)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipe.direction = .right
        mainView.addGestureRecognizer(swipe)
        let swipe2 = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipe2.direction = .left
        mainView.addGestureRecognizer(swipe2)

    }
    
    @objc func handleSwipeRight(_ sender : Any) {
        if !tabBarVisible {
            NotificationCenter.default.post(name: NSNotification.Name("ToggleMoreTab"), object: nil)
        }
    }
    
    @objc func handleSwipeLeft(_ sender : Any) {
        if tabBarVisible {
            NotificationCenter.default.post(name: NSNotification.Name("ToggleMoreTab"), object: nil)
        }
    }
    
    @objc func handleTap(_ sender : Any) {
        print("Here")
        if tabBarVisible {
            NotificationCenter.default.post(name: NSNotification.Name("ToggleMoreTab"), object: nil)
        }
    }
    
    @objc func toggleSideMenu(_ sender : Any) {
        if tabBarVisible {
            moreTabXPos.constant = -225
        }
        else {
            moreTabXPos.constant = 0
        }
        tabBarVisible = !tabBarVisible
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

}
