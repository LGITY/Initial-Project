//
//  AddGroup.swift
//  Login-Screen
//
//  Created by Davis Booth on 8/23/18.
//  Copyright © 2018 Brad Levin. All rights reserved.
//

import UIKit

class AddGroup: UITableViewCell {

    var parentView: profile?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fullInit(view: profile) {
        self.selectionStyle = UITableViewCellSelectionStyle.none
        parentView = view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func createButtonText(_ sender: Any) {
        createButton()
    }
    
    @IBAction func createButtonImage(_ sender: Any) {
        createButton()
    }
    
    func createButton() {
        parentView!.performSegue(withIdentifier: "toGroupCreation", sender: parentView)
    }
    
    
}
