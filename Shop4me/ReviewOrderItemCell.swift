//
//  ReviewOrderItemCell.swift
//  Shop4me
//
//  Created by mac on 8/6/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ReviewOrderItemCell: UITableViewCell {

    
    let BaseImageURL = MyVariables.BaseImageURL
    
    static let reuseIdentifier = "CartItemCell"
    
    var cartItemQuantityChangedCallback: (() -> ())!
    
    fileprivate weak var cartItem: CartItem!
    
    // MARK: Properties
    
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    
    @IBOutlet fileprivate weak var quantityLabel: UILabel!
    
    @IBOutlet fileprivate weak var productImageView: UIImageView!
    
    
    override func awakeFromNib() {
        // Resize the stepper.
        //quantityStepper.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // Draw a border layer at the top.
        // self.drawTopBorderWithColor(UIColor.furniBrownColor(), height: 0.5)
        
    }
    
    func configureWithCartItem(_ cartItem: CartItem) {
        self.cartItem = cartItem
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        // Assign the labels.
        nameLabel.text = cartItem.product.name
        priceLabel.text = numberFormatter.string(from: NSNumber(value:Int((cartItem.product.price ))!))! + "/="
        quantityLabel.text = "Quantity: \(cartItem.quantity)"
        
        // Load the image from the network and give it the correct aspect ratio.
        //  productImageView.af_setImageWithURL(cartItem.product.imageURL)
        //productImageView.af_setImage(withURL: URL(string:cartItem.product.imageURL)!)
        
        let imageName = cartItem.product.imageURL.components(separatedBy: "/")[1]
        let imgURL = URL(string: BaseImageURL+imageName)
        productImageView.sd_setImage(with: imgURL)
    }

}
