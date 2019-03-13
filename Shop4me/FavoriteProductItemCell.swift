//
//  FavoriteProductItemCell.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/13/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class FavoriteProductItemCell: UITableViewCell {
    var cartItemQuantityChangedCallback: (() -> ())!
    
    let BaseURL = MyVariables.BaseURL+"product/"
    let BaseImageURL = MyVariables.BaseImageURL
    
   
     var productId: Int!
    
    
    @IBOutlet weak var productDescLabel: UILabel!
    

    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var addToCartButton: UIButton!
   
    @IBOutlet weak var favoriteButton: UIButton!

    @IBAction func addToCartButtonTapped(_ sender: Any) {
        
    }

    var p:ProductModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithFavoriteProduct(_ productId: Int) {
        favoriteButton.setImage(UIImage.favoriteImageForFavoritedState(true), for: UIControlState())
        self.productId = productId
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        //get product details
        
        Alamofire.request(BaseURL+String(productId)).responseJSON{ response in
            
            if let JSON = response.result.value{
                let arr = JSON as? NSArray
                
                if arr!.count > 0 {
                    for i in 0 ... arr!.count - 1 {
                        
                        let prod = arr?[i] as? [String: Any]
                        let name = prod!["name"] as? String!
                        let desc =  prod!["description"] as? String!
                        let price = prod!["price"] as? String!
                        let imageURL =  prod!["image"] as? String!
                        let id =  prod!["product_id"] as? Int!
                        
                         self.p = ProductModel(name: name!,
                                             desc:desc!,
                                             price: price!.components(separatedBy: ".")[0],
                                             imageURL: imageURL!, id: id!)
                        
        FavoriteProducts.sharedInstance.items.append(self.p)
                        
                        // Assign the labels.
                        self.productNameLabel.text = self.p.name
                          self.productDescLabel.text = self.p.desc
                        self.productPriceLabel.text = numberFormatter.string(from: NSNumber(value:Int((self.p.price ))!))! + "/="
                        let imageName = self.p.imageURL.components(separatedBy: "/")[1]
                        let imgURL = URL(string: self.BaseImageURL+imageName)
                        self.productImage.sd_setImage(with: imgURL)
                        
                    }
                }
            }
            
        }
  
    }

}
