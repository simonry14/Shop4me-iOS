//
//  OrderItemCell.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/10/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit

class OrderItemCell: UITableViewCell {
    
    @IBOutlet weak var orderIdLabel: UILabel!

    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func payTapped(_ sender: Any) {
    }
    
    
    @IBOutlet weak var payBtn: UIButton!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
