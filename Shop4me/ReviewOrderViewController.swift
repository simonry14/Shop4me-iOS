//
//  ReviewOrderViewController.swift
//  Shop4me
//
//  Created by mac on 8/6/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase
import Toast_Swift

class ReviewOrderViewController: UITableViewController {

    var shippingCharge:Float = 10000
    var serviceCharge:Float = 0
    let BaseURL = MyVariables.BaseURL
    let defaults = UserDefaults.standard
    let myCart = Cart.sharedInstance.items
    var address = ""
    var telephone = ""
    //var comment = ""
    var payment = ""
    var totalF = Cart.sharedInstance.totalAmount()
    var iid:String = ""
    var time:String = ""
    
    fileprivate let cart = Cart.sharedInstance
    //let defaults = UserDefaults.standard
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // Order price in cents.
    fileprivate var orderPriceCents: Float = 0
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
 
    }
    
    
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cart.isEmpty() ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the cart.
        return cart.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewOrderItemCell.reuseIdentifier, for: indexPath) as! ReviewOrderItemCell
        
        // Find the corresponding cart item.
        let cartItem = cart.items[indexPath.row]
        
        // Keep a weak reference on the table view.
        cell.cartItemQuantityChangedCallback = { [unowned self] in
            self.refreshCartDisplay()
            self.tableView.reloadData()
        }
        
        // Configure the cell with the cart item.
        cell.configureWithCartItem(cartItem)
        self.tabBarItem.badgeValue = String(Cart.sharedInstance.productCount())
        // Return the cart item cell.
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Remove this item from the cart and refresh the table view.
        cart.items.remove(at: indexPath.row)
        
        // Either delete some rows within the section (leaving at least one) or the entire section.
        if cart.items.count > 0 {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        }
        
        self.tabBarItem.badgeValue = String(Cart.sharedInstance.productCount())
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableCell(withIdentifier: ReviewOrderFooterCell.reuseIdentifier) as! ReviewOrderFooterCell
        
        // Configure the footer with the cart.
        footerView.configureWithCart(cart,ad: address,ti: time,pa: payment)
        
        footerView.payButton.addTarget(self, action: #selector(ReviewOrderViewController.orderButton), for: UIControlEvents.touchUpInside)
        
        // Return the footer view.
        return footerView.contentView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       // let tableViewHeight = UIScreen.main.bounds.height - tableView.frame.origin.y - 40
       // return max(300, tableViewHeight - CGFloat(100 * cart.items.count))
        return 300
        
    }
    
    // MARK: Utilities
    
    @objc fileprivate func cartUpdatedNotificationReceived() {
        // Update the price of the cart in cents.
        orderPriceCents = cart.totalAmount() * 100.0
        
        // Refresh the cart display.
        self.refreshCartDisplay()
    }
    
    fileprivate func refreshCartDisplay() {
        let cartTabBarItem = self.parent!.tabBarItem
        
        // Update the tab bar badge.
        let productCount = cart.productCount()
        cartTabBarItem!.badgeValue = productCount > 0 ? String(productCount) : nil
        
        // Update the tab bar icon.
        if productCount > 0 {
            cartTabBarItem?.image = UIImage(named: "Cart-Full")
            cartTabBarItem?.selectedImage = UIImage(named: "Cart-Full-Selected")
        } else {
            cartTabBarItem?.image = UIImage(named: "Cart")
            cartTabBarItem?.selectedImage = UIImage(named: "Cart-Selected")
        }
        
     
    }
    

    
    func orderButton(){
        
        
        if payment == "Mobile Money" || payment == "Debit Card" {
            //go to insta payment page
            let  pdVc = storyboard?.instantiateViewController(withIdentifier: "InstapayViewController") as! InstapayViewController
            self.navigationController?.pushViewController(pdVc, animated: true)
       
            
        }else {
            //place order
            //Show spinner
            self.view.makeToastActivity(.center)
         addOrder()
            
        }
    }
    
    func addOrder(){
        let fullname = defaults.string(forKey: "fullname")
        let email = defaults.string(forKey: "email")
        let customerid = defaults.string(forKey: "openCartId")
        ///  let customerid = "1"
        
        let firstname = fullname?.components(separatedBy: " ").first
        let lastname = fullname?.components(separatedBy: " ").last
        let total = String(totalF+shippingCharge+serviceCharge)
        
        let userUR = self.BaseURL+"add_order?customerid=\(customerid!)&firstname=\(firstname!)&lastname=\(lastname!)&email=\(email!)&telephone=\(telephone)&payment=\(payment)&address=\(address)&comment=\(time)&total=\(total)"
        
        let userURL = userUR.replacingOccurrences(of: " ", with: "%20")
        Alamofire.request(userURL).responseString{ response in
            if let JSON = response.result.value{
                let openCartId = JSON as? String
                let index = openCartId?.index((openCartId?.startIndex)!, offsetBy: 1)
                self.iid = (openCartId?.substring(from: index!))!
                // print(self.iid)
                self.addOrderProducts(orderId: self.iid)
                
            }
        }
        
    }
    
    func addOrderProducts(orderId: String){
        let model = ""
        var prod = ""
        for item in myCart{
            
            let userUR = self.BaseURL+"add_order_products?orderid=\(orderId)&productid=\(String(describing: item.product.id!))&name=\(item.product.name)&model=\(model)&quantity=\(String(item.quantity))&price=\(item.product.price)&total=\(String(item.quantity*Int(item.product.price)!))"
            
            let userURL = userUR.replacingOccurrences(of: " ", with: "%20")
            Alamofire.request(userURL).responseString{ response in
                if let JSON = response.result.value{
                    
                    
                }
            }
            prod = "\(prod) \(String(item.quantity)) X \(item.product.name)<br>"
        }
        
        //sen order email
        let fullname = defaults.string(forKey: "fullname")
        let email = defaults.string(forKey: "email")
        let firstname = fullname?.components(separatedBy: " ").first
        
        sendOrderEmail(email: email!, names: firstname!, orderid: iid, products: prod)
        
        
        
        //remove items from cart
        Cart.sharedInstance.reset()
        
        // Go to order success page
        let  pdVc = storyboard?.instantiateViewController(withIdentifier: "OrderSuccessfulViewController") as! OrderSuccessfulViewController
        self.navigationController?.pushViewController(pdVc, animated: true)
        
        
    }
    
    
    func sendOrderEmail(email:String, names:String, orderid:String, products:String ){
        let total = String(totalF+shippingCharge+serviceCharge)
        let userUR = self.BaseURL+"sendOrderEmail?email=\(email)&names=\(names)&total=\(total)&address=\(address)&payment=\(payment)&orderid=\(orderid)&products=\(products)"
        let userURL = userUR.replacingOccurrences(of: " ", with: "%20")
        Alamofire.request(userURL).responseString{ response in
            if let JSON = response.result.value{
                
            }
        }
        
    }
    
 
}
