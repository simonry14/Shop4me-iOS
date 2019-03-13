//
// Copyright (C) 2015 Twitter, Inc. and other contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//         http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import AlamofireImage

final class ProductCell: UICollectionViewCell {

    // MARK: Properties

    static let reuseIdentifier = "ProductCell"

    var product: Product!

    @IBOutlet fileprivate weak var nameLabel: UILabel!

    @IBOutlet fileprivate weak var priceLabel: UILabel!

    @IBOutlet fileprivate weak var retailPriceLabel: UILabel!

    @IBOutlet fileprivate weak var percentOffLabel: UILabel!

    @IBOutlet fileprivate weak var imageView: UIImageView!

    @IBOutlet fileprivate weak var favoriteButton: UIButton!

    @IBOutlet fileprivate weak var separatorHeightConstraint: NSLayoutConstraint!

    fileprivate var favorited: Bool = false {
        didSet {
            favoriteButton.setImage(UIImage.favoriteImageForFavoritedState(favorited), for: UIControlState())
        }
    }

    // MARK: IBActions

    @IBAction fileprivate func favoriteButtonTapped(_ sender: AnyObject) {
        let favorite = !self.favorited
        self.favorited = favorite

        let product = self.product
     // save favorite product
    }

    // MARK: View Life Cycle

    override func awakeFromNib() {
        // Draw a border around the cell.
        layer.masksToBounds = false
        layer.borderColor = UIColor.furniBrownColor().cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 3
        separatorHeightConstraint.constant = 0.5
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        retailPriceLabel.text = nil
        percentOffLabel.text = nil
    }

    func configureWithProduct(_ product: Product) {
        // Keep a reference on the model.
        self.product = product

        // Add the product name.
        nameLabel.text = product.name

        // Load the image from the network and give it the correct aspect ratio.
        let size = CGSize(width: imageView.bounds.width, height: imageView.bounds.height)
        imageView.af_setImage(
            withURL: product.imageURL,
            placeholderImage: UIImage(named: "Placeholder"),
            filter: AspectScaledToFillSizeFilter(size: size),
            imageTransition: .crossDissolve(0.6)
        )

        // Set the favorited state to adjust the icon accordingly.
       // favorited = product.isFavorited

        // Add the current and retail prices with their currency.
        priceLabel.text = product.price as? String
        if product.price < product.retailPrice && product.percentOff > 0 {
            let retailPriceString = String(product.retailPrice)
            let attributedRetailPrice = NSMutableAttributedString(string: retailPriceString)
            attributedRetailPrice.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, (retailPriceString.characters.count)))
            attributedRetailPrice.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.furniDarkGrayColor(), range: NSMakeRange(0, (retailPriceString.characters.count)))
            retailPriceLabel.attributedText = attributedRetailPrice
            percentOffLabel.text = "-\(product.percentOff)%"
        }
    }
}
