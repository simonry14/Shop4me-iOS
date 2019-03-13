//
//  ProductItemCell.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/7/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit

class ProductItemCell: UITableViewCell {
    
    @IBOutlet weak var productDescLabel: UILabel!

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!

    
    @IBOutlet weak var favoriteButton: UIButton!

    @IBOutlet weak var quantityStepper: UIStepper!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
