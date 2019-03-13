//
//  MyOrdersViewController.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/5/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MyOrdersViewController: UITableViewController {

    var ordeR: OrderModel?
    var orderList = [OrderModel]()
    
    let BaseURL = MyVariables.BaseURL+"all_orders/"
    let BaseImageURL = MyVariables.BaseImageURL
    let defaults = UserDefaults.standard
    
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    func cartButtonTapped(){
        
        let  pdVc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        pdVc.selectedIndex = 2
        self.navigationController?.pushViewController(pdVc, animated: true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 let customerid = defaults.string(forKey: "openCartId")
        Alamofire.request(BaseURL+customerid!).responseJSON{ response in
            
            if let JSON = response.result.value{
                let arr = JSON as? NSArray
                
                if arr!.count > 0 {
                    for i in 0 ... arr!.count - 1 {
                        
                        let prod = arr?[i] as? [String: Any]
                        let order_id = prod!["order_id"] as? Int!
                        let order_date =  prod!["date_added"] as? String!
                        let order_total =  prod!["total"] as? String!
                        let order_status =  prod!["name"] as? String!
                        let payment_method =  prod!["payment_method"] as? String!
                           let shipping_address =  prod!["shipping_address_1"] as? String!
                        let time =  prod!["comment"] as? String!
                        
                        let p = OrderModel(orderId: order_id!,
                                           orderDate:order_date!,
                                           orderTotal: order_total!, orderStatus: order_status!, paymentMethod: payment_method!, shippingAddress:shipping_address!, time: time!)
                        
                        self.orderList.append(p)
                        
                    }
                    self.tableView.reloadData()
                }
                
                
            }
            //   self.tableView.reloadData()
        }
        let catItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Cart-Selected"), landscapeImagePhone: UIImage(named: "Cart-Selected"), style: .plain, target: self, action: #selector(MyOrdersViewController.cartButtonTapped))
        catItem.tintColor = UIColor.white
        
        navigationItem.setRightBarButton(catItem, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderList.count
    }

    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as? OrderItemCell else{
            
            return OrderItemCell()
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        let order: OrderModel
        order = orderList[indexPath.row]
        cell.orderIdLabel.text = "Order Id: "+String(order.orderId)
        cell.orderDateLabel.text = order.orderDate
       cell.orderTotalLabel.text = numberFormatter.string(from: NSNumber(value:Int(order.orderTotal.components(separatedBy: ".")[0])!))! + "/="
        cell.orderStatusLabel.text = order.orderStatus
        
        
        return cell
    }
 

    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ordeR = orderList[indexPath.row]
        self.performSegue(withIdentifier: "OrderDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderDetailSegue"{
            
            let pdVc : OrderDetailsViewController = segue.destination as! OrderDetailsViewController
            pdVc.order = ordeR
       
            
            // cVc.ctName = catTitle!
            
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
