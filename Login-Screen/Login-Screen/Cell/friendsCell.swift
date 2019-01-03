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
    @IBOutlet weak var friendsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func commonInit(name: String = "", username: String = "")
    {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        nameLabel.text = name
        usernameLabel.text = username
        friendsLabel.text = "FRIENDS"
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
