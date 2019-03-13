//
//  SubCategoryViewController.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/6/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import AlamofireImage
import SDWebImage
import Toast_Swift

class SubCategoryViewController: UITableViewController, IndicatorInfoProvider {
    
    var productName:String?
    var productPrice:String?
    var productDesc:String?
    var productImage:Data?
    var productId:String?
    
       var prodct:ProductModel?

    var topName:String?
    var catId:String?
     var productList = [ProductModel]()
    let BaseURL = MyVariables.BaseURL+"all_from_category/"
    let BaseImageURL = MyVariables.BaseImageURL
    
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        
       
        //Show spinner
        self.view.makeToastActivity(.center)
        //LOAD DATA FROM API
        
        
         Alamofire.request(BaseURL+catId!).responseJSON{ response in

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
            
            let p = ProductModel(name: name!,
                                 desc:desc!,
                                 price: price!.components(separatedBy: ".")[0],
                                 imageURL: imageURL!, id: id!)
            
            self.productList.append(p)
            
        }
           self.tableView.reloadData()
            self.view.hideToastActivity()
        }
       
        
    }else{
         self.view.hideToastActivity()
            }
       //   self.tableView.reloadData()
         }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 override   func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
  
 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
   override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
  override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "myproductcell", for: indexPath) as? ProductItemCell else{
    
        return ProductItemCell()
    }
let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal

        let product: ProductModel
        product = productList[indexPath.row]
        cell.productNameLabel.text = product.name
         cell.productDescLabel.text = product.desc
      //  cell.productPriceLabel.text = String(product.price)+"/="
    cell.productPriceLabel.text = numberFormatter.string(from: NSNumber(value:Int(product.price)!))! + "/="
   let imageName = product.imageURL.components(separatedBy: "/")[1]
    let imgURL = URL(string: BaseImageURL+imageName)
    cell.productImage.sd_setImage(with: imgURL)
   
    //check if this product is already in cart and set the right value in the quantity label
    if Cart.sharedInstance.isProductInCart(product: product) {
        //get current quantity of product and assign it to label AND value of STEPPER
        let quant = Cart.sharedInstance.quantityOfThisProductInCart(product: product)
        cell.quantityLabel.text = String(quant)
        cell.quantityStepper.value = Double(quant)
    }
    
    if Favorite.sharedInstance.isProductFavorite(productId: product.id!){
  cell.favoriteButton.setImage(UIImage.favoriteImageForFavoritedState(true), for: UIControlState())
    }
    
    cell.quantityStepper.tag = indexPath.row
    cell.quantityStepper.addTarget(self, action: #selector(SubCategoryViewController.quantityStepperValueChanged), for: UIControlEvents.touchUpInside)
    
    cell.favoriteButton.tag = indexPath.row
   cell.favoriteButton.addTarget(self, action: #selector(SubCategoryViewController.favoriteButtonTapped), for: UIControlEvents.touchUpInside)
        
        return cell
    }
 
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
      let itemInfo = IndicatorInfo(title: topName!)
        return itemInfo
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! ProductItemCell
        let product: ProductModel
        product = productList[indexPath.row]
        productId = String(describing: product.id!)
        productName = product.name
        productPrice = product.price
        productDesc = product.desc
        productImage = (currentCell.productImage.image?.sd_imageData())!
        
       
         prodct = product
        
        self.performSegue(withIdentifier: "ProductDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetailSegue"{
            
            let pdVc : ProductDetailViewController = segue.destination as! ProductDetailViewController
             pdVc.productImage = productImage!
            pdVc.thisProduct = prodct
            
        }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

func quantityStepperValueChanged(_ sender: UIStepper) {
     let p = productList[sender.tag]
    let IP:  IndexPath = IndexPath(row: sender.tag, section: 0)
       let cellWhoseStepperwasClicked = tableView.cellForRow(at: IP) as! ProductItemCell
      let value = Int(sender.value)
    
    if value > Int(cellWhoseStepperwasClicked.quantityLabel.text!)!{ //incement pressed
        Cart.sharedInstance.addProduct(p)
        cellWhoseStepperwasClicked.quantityLabel.text = String(value)
    } else{
        
        Cart.sharedInstance.reduceProduct(p)
        cellWhoseStepperwasClicked.quantityLabel.text = String(value)
    }

    }
    
    func favoriteButtonTapped(_ sender: UIStepper) {
        let p = productList[sender.tag]
        let IP:  IndexPath = IndexPath(row: sender.tag, section: 0)
         let cellWhosefavoriteButtonwasClicked = tableView.cellForRow(at: IP) as! ProductItemCell
        
        if Favorite.sharedInstance.isProductFavorite(productId: p.id!) {
        cellWhosefavoriteButtonwasClicked.favoriteButton.setImage(UIImage.favoriteImageForFavoritedState(false), for: UIControlState())
            Favorite.sharedInstance.removeProduct(p.id!)
        }else{
         cellWhosefavoriteButtonwasClicked.favoriteButton.setImage(UIImage.favoriteImageForFavoritedState(true), for: UIControlState())
            Favorite.sharedInstance.addProduct(p.id!)
        }
        
     
        
        
      //  let favorite = !self.favorited
       // self.favorited = favorite
        
    }
    
}
