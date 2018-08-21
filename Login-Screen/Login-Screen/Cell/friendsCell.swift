//
//  friendsCell.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/20/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class friendsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Make this shit happen bitch
        
    }
    
    func commonInit(name: String = "", username: String = "") {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        nameLabel.text = name
        usernameLabel.text = username
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
