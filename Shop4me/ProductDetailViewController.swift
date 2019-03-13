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
import Alamofire

final class ProductDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   /*
    var productName:String?
    var productPrice:String?
    var productDesc:String?
    var productId:String?*/
     var productImage:Data?
    var productId:String = ""
    
    var thisProduct:ProductModel?

    // MARK: Properties
    let BaseURL = MyVariables.BaseURL+"all_related_products/"
    let BaseImageURL = MyVariables.BaseImageURL

         var productList = [ProductModel]()
    
    let numberFormatter = NumberFormatter()
   

    @IBOutlet weak var RelatedProductCollectionView: UICollectionView!
  //  var product: Product!

    @IBOutlet fileprivate weak var nameLabel: UILabel!

    @IBOutlet fileprivate weak var priceLabel: UILabel!

    @IBOutlet fileprivate weak var imageView: UIImageView!

    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
   
    @IBOutlet weak var quantityLabel: UILabel!

    @IBOutlet fileprivate weak var favoriteButton: UIButton!

    fileprivate var favorited: Bool = false {
        didSet {
            favoriteButton.setImage(UIImage.favoriteImageForFavoritedState(favorited), for: UIControlState())
        }
    }

    
    @IBAction func quantityStepperValueChanged(_ sender: UIStepper) {
        
        let value = Int(sender.value)
        
        if value > Int(quantityLabel.text!)!{ //incement pressed

            Cart.sharedInstance.addProduct(thisProduct!)
            quantityLabel.text = String(value)
        } else{
        
            Cart.sharedInstance.reduceProduct(thisProduct!)
              quantityLabel.text = String(value)
        }
        
    }
    
    @IBOutlet weak var quantityStepper: UIStepper!
    
    // MARK: IBActions

    @IBAction fileprivate func favoriteButtonTapped(_ sender: AnyObject) {
        
        if Favorite.sharedInstance.isProductFavorite(productId: (thisProduct?.id)!) {
 favoriteButton.setImage(UIImage.favoriteImageForFavoritedState(false), for: UIControlState())
            Favorite.sharedInstance.removeProduct((thisProduct?.id)!)
        }else{
favoriteButton.setImage(UIImage.favoriteImageForFavoritedState(true), for: UIControlState())
            Favorite.sharedInstance.addProduct((thisProduct?.id)!)
        }
        
    }

    @IBAction fileprivate func addToCartButtonTapped(_ sender: AnyObject) {
        //Cart.sharedInstance.addProduct(product)
    }

 
    func cartButtonTapped(){
    //    let  pdVc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let  pdVc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
      //  pdVc.productDesc = productDesc!
  pdVc.selectedIndex = 2
        self.navigationController?.pushViewController(pdVc, animated: true)
    
    }
    
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.RelatedProductCollectionView.dataSource = self
        self.RelatedProductCollectionView.delegate = self

        navigationItem.title = thisProduct?.name
        let catItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Cart-Selected"), landscapeImagePhone: UIImage(named: "Cart-Selected"), style: .plain, target: self, action: #selector(ProductDetailViewController.cartButtonTapped))
        catItem.tintColor = UIColor.white
        
        navigationItem.setRightBarButton(catItem, animated: false)

        // Add product name and description labels.
       
         numberFormatter.numberStyle = NumberFormatter.Style.decimal
        nameLabel.text = thisProduct?.name
        descriptionLabel.text = thisProduct?.desc
        priceLabel.text = numberFormatter.string(from: NSNumber(value:Int((thisProduct?.price)!)!))! + "/="
        
        //check if this product is already in cart and set the right value in the quantity label
        if Cart.sharedInstance.isProductInCart(product: thisProduct!) {
        //get current quantity of product and assign it to label AND value of STEPPER
            let quant = Cart.sharedInstance.quantityOfThisProductInCart(product: thisProduct!)
            quantityLabel.text = String(quant)
            quantityStepper.value = Double(quant)
        }
        
        if Favorite.sharedInstance.isProductFavorite(productId: Int((thisProduct?.id)!)){
          favoriteButton.setImage(UIImage.favoriteImageForFavoritedState(true), for: UIControlState())
        }
      

        // Load the image from the network and give it the correct aspect ratio.
        let size = CGSize(width: imageView.bounds.width, height: imageView.bounds.height)
        
        
     imageView.image = UIImage(data: productImage!)
        
    /*
        imageView.af_setImage(
            withURL: product.imageURL,
            placeholderImage: UIImage(named: "Placeholder"),
            filter: AspectScaledToFitSizeFilter(size: size),
            imageTransition: .crossDissolve(0.6)
        ) */

        // Set the icon if the product has been favorited.
        //self.favorited = product.isFavorited

        // Draw a border around the product image and put a white background.
        imageView.layer.masksToBounds = false
        imageView.layer.backgroundColor = UIColor.white.cgColor
        imageView.layer.borderColor = UIColor.furniBrownColor().cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 3

        // Decorate the button.
        //addToCartButton.decorateForFurni()
        
        //LOAD DATA FROM API
        productId = (thisProduct?.id?.description)!
        
        Alamofire.request(BaseURL+productId).responseJSON{ response in
            
            if let JSON = response.result.value{
                let arr = JSON as? NSArray
                
                if arr!.count > 0 {
                    for i in 0 ... arr!.count - 1 {
                        
                        let prod = arr?[i] as? [String: Any]
                        let name = prod!["name"] as? String!
                        let desc =  prod!["description"] as? String!
                        let price = prod!["price"] as? String!
                        let imageURL =  prod!["image"] as? String!
                         let id = prod!["product_id"] as? Int!
                        
                        let p = ProductModel(name: name!,
                                             desc: desc!,
                                             price: price!.components(separatedBy: ".")[0],
                                             imageURL: imageURL!, id: id!)
                        
                        self.productList.append(p)
                        
                    }
                    self.RelatedProductCollectionView.reloadData()
                }
                
                
            }
                self.RelatedProductCollectionView.reloadData()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "relatedcell", for: indexPath) as! RelatedProductViewCell
        let product: ProductModel
        product = productList[indexPath.row]
        let imageName = product.imageURL.components(separatedBy: "/")[1]
        let imgURL = URL(string: BaseImageURL+imageName)
        cell.prodImage.sd_setImage(with: imgURL)
        cell.prodNameLabel.text = product.name
        cell.prodPriceLabel.text = numberFormatter.string(from: NSNumber(value:Int((product.price))!))! + "/="
        
      //  cell.catName.numberOfLines = 0
     //   cell.catName.lineBreakMode = .byWordWrapping
        //cell.catName.sizeToFit()
        // Configure the cell
        
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! RelatedProductViewCell
      /*  productId = currentCell.prodIdLabel.text!
        productName = currentCell.prodNameLabel.text!
        productPrice = currentCell.prodPriceLabel.text!
        productDesc = currentCell.prodDescLabel.text!
        productImage = (currentCell.prodImage.image?.sd_imageData())!*/
        
        let product: ProductModel
        product = productList[indexPath.row]
        
   /*     productId = String(describing: product.id!)
        productName = product.name
        productPrice = product.price
        productDesc = product.description*/
        productImage = (currentCell.prodImage.image?.sd_imageData())!
        
       // var pdVc: UIViewController!
     let  pdVc = storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
      /*  pdVc.productDesc = productDesc!
        pdVc.productName = productName!
        pdVc.productPrice = productPrice!
       
        pdVc.productId = productId! */
         pdVc.productImage = productImage!
        pdVc.thisProduct = product
        
        self.navigationController?.pushViewController(pdVc, animated: true)
        
      //  self.present(pdVc, animated: true, completion: nil)
        
       // self.performSegue(withIdentifier: "RelatedProductsSegue", sender: currentCell)
    }
    

}
