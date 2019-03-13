//
//  OrderDetailsViewController.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/10/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var order: OrderModel?
    
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var shippingAddressLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var productList = [ProductModel]()
    
    let BaseURL = MyVariables.BaseURL+"all_products_in_order/"
    let BaseImageURL = MyVariables.BaseImageURL
    
    let numberFormatter = NumberFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        orderIdLabel.text = String(order!.orderId)
        orderTotalLabel.text = numberFormatter.string(from: NSNumber(value:Int(order!.orderTotal.components(separatedBy: ".")[0])!))! + "/="
        orderDateLabel.text = order!.orderDate
        paymentMethodLabel.text = order!.paymentMethod
        shippingAddressLabel.text = order!.shippingAddress
        orderTime.text = order!.time
        
        Alamofire.request(BaseURL+String(order!.orderId)).responseJSON{ response in
            
            if let JSON = response.result.value{
                let arr = JSON as? NSArray
                
                if arr!.count > 0 {
                    for i in 0 ... arr!.count - 1 {
                        
                        let prod = arr?[i] as? [String: Any]
                        let name = prod!["name"] as? String!
                        let quantity =  prod!["quantity"] as? Int!
                        let price = prod!["price"] as? String!
                        let imageURL =  prod!["image"] as? String!
                        
                        
                        let p = ProductModel(name: name!,
                                             quantity:quantity!,
                                             price: price!.components(separatedBy: ".")[0],
                                             imageURL: imageURL!)
                        
                        self.productList.append(p)
                        
                    }
                    self.tableView.reloadData()
                }
                
                
            }
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderdetailproductcell", for: indexPath) as? OrderDetailProductCell else{
            
            return OrderDetailProductCell()
        }
        
        
        
        
        let product: ProductModel
        product = productList[indexPath.row]
        cell.quantityLabel.text = String(describing: product.quantity!)
        cell.nameLabel.text = product.name
        cell.priceLabel.text =  numberFormatter.string(from: NSNumber(value:Int(product.price)!))! + "/="
        
        let imageName = product.imageURL.components(separatedBy: "/")[1]
        let imgURL = URL(string: BaseImageURL+imageName)
        cell.iamgeView.sd_setImage(with: imgURL)
        
        
        return cell
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
