//
//  Home.swift
//  Login-Screen
//
//  Created by Davis Booth on 11/24/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var mainTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        //Creates the nib for the table view to reference
        let nibName = UINib(nibName: "HomePostCell", bundle: nil)
        
        //registers the nib for use with the table view
        mainTableView.register(nibName, forCellReuseIdentifier: "HomePostCell")
        
        //disables scrollbar in both directions
        mainTableView.showsHorizontalScrollIndicator = false
        mainTableView.showsVerticalScrollIndicator = false
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    

}
