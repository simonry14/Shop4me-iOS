//
//  OrderDetailProductCell.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/10/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit

class OrderDetailProductCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iamgeView: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
