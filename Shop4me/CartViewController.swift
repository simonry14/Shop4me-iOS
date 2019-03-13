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
import FirebaseDatabase
import Toast_Swift



final class CartViewController: UITableViewController {

    fileprivate let cart = Cart.sharedInstance
let defaults = UserDefaults.standard
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    // Order price in cents.
    fileprivate var orderPriceCents: Float = 0

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Put a label as the background view to display when the cart is empty.
        let emptyCartLabel = UILabel()
        emptyCartLabel.numberOfLines = 0
        emptyCartLabel.textAlignment = .center
  //      emptyCartLabel.textColor = UIColor.furniDarkGrayColor()
        emptyCartLabel.font = UIFont.systemFont(ofSize: CGFloat(20))
        emptyCartLabel.text = "Your cart is empty.\nBrowse the various product categories and add products to your cart! "
        tableView.backgroundView = emptyCartLabel
        tableView.backgroundView?.isHidden = true
        tableView.backgroundView?.alpha = 0
        self.tabBarItem.badgeValue = String(Cart.sharedInstance.productCount())
         self.parent?.title = "Shopping Cart"
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tableView.reloadData()
        toggleEmptyCartLabel()
        self.parent?.title = "Shopping Cart"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.reuseIdentifier, for: indexPath) as! CartItemCell

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
        let footerView = tableView.dequeueReusableCell(withIdentifier: CartFooterCell.reuseIdentifier) as! CartFooterCell

        // Configure the footer with the cart.
        footerView.configureWithCart(cart)
        
         footerView.payButton.addTarget(self, action: #selector(CartViewController.checkoutButton), for: UIControlEvents.touchUpInside)

        // Return the footer view.
        return footerView.contentView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let tableViewHeight = UIScreen.main.bounds.height - tableView.frame.origin.y - tabBarController!.tabBar.bounds.height - 40
        return max(110, tableViewHeight - CGFloat(100 * cart.items.count))
    
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

        // Toggle the empty cart label if needed.
        toggleEmptyCartLabel()
    }

    fileprivate func toggleEmptyCartLabel() {
        if cart.isEmpty() {
            UIView.animate(withDuration: 0.15, animations: {
                self.tableView.backgroundView!.isHidden = false
                self.tableView.backgroundView!.alpha = 1
                 self.tabBarItem.badgeValue = nil
            }) 
        } else {
            UIView.animate(withDuration: 0.15,
                animations: {
                    self.tableView.backgroundView!.alpha = 0
                },
                completion: { finished in
                    self.tableView.backgroundView!.isHidden = true
                }
            )
        }
    }
    
    func checkoutButton(){
        
         let address = defaults.string(forKey: "address")
            let phone1 = defaults.string(forKey: "phone1")
        
        if address == "" || phone1 == "" {
            
   presentAlert()
            
        }else {
            
            let  pdVc = storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
            self.navigationController?.pushViewController(pdVc, animated: true)
        
        }
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Address & Phone Number Required", message: "Please Enter your address and phone number below", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
        
                let address = field.text!
                if let field2 = alertController.textFields?[1] {
                 let phoneNumber = field2.text!
                    
                   
                    
                 if address != "" && phoneNumber != "" {
                    self.saveText(address: address,phoneNumber: phoneNumber)
                    
                 }else{
                    //Toast
                    self.view.makeToast("Address or Phone Number Empty")
                    self.presentAlert()
                    }
                    
                }else {
                    self.view.makeToast("Please Enter PhoneNumber", duration: 2.0, position: .center)
                }
                
                
              
            } else {
                  self.view.makeToast("Please Enter Address", duration: 2.0, position: .center)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(cancelAction)
        
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Address"
           textField.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Phone Number"
             textField.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
           
        }
        
        alertController.addAction(confirmAction)
       // alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func saveText(address:String,phoneNumber:String){
        
        let userId = defaults.string(forKey: "userId")
        let usersRef = Database.database().reference().child("Users")
        let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
        
        q.observeSingleEvent(of: .value, with: { DataSnapshot in
            if DataSnapshot.exists(){
                for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                    let userObject = users.value as? [String: AnyObject]
                    let   uKey = (users.key as? String)!
     
                        usersRef.child(uKey+"/address").setValue(address)
                        self.defaults.set(address, forKey: "address")
                    usersRef.child(uKey+"/phone1").setValue(phoneNumber)
                    self.defaults.set(phoneNumber, forKey: "phone1")

                        self.defaults.synchronize()
                  self.goToOrder()
                }
            }else{
                print("User NOT There")
            }
        })
        
       /*
        q.observeSingleEvent(of: .value, with: { DataSnapshot in
            if DataSnapshot.exists(){
                for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                    let userObject = users.value as? [String: AnyObject]
                    let   uKey = (users.key as? String)!
                    
                    usersRef.child(uKey+"/phone1").setValue(phoneNumber)
                    self.defaults.set(phoneNumber, forKey: "phone1")
                    self.defaults.synchronize()
                }
            }else{
                print("User NOT There")
            }
        })*/
        
    }
    
    
    func goToOrder(){
        let  pdVc = storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        self.navigationController?.pushViewController(pdVc, animated: true)
    }

    
}
