//
//  ProfileCell.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/19/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var customerEmail: UILabel!
    @IBOutlet weak var customerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
