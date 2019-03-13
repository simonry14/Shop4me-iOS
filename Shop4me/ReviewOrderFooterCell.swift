//
//  ReviewOrderFooterCell.swift
//  Shop4me
//
//  Created by mac on 8/6/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ReviewOrderFooterCell: UITableViewCell {

    static let reuseIdentifier = "CartFooterCell"
    let defaults = UserDefaults.standard
    
    // MARK: Properties
    
    @IBOutlet fileprivate weak var feeTitle: UILabel!
    @IBOutlet fileprivate weak var totalItemsLabel: UILabel!
    
    @IBOutlet fileprivate weak var subtotalPriceLabel: UILabel!
    
    @IBOutlet fileprivate weak var shippingPriceLabel: UILabel!
    
    @IBOutlet fileprivate weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    
    @IBOutlet fileprivate weak var address: UILabel!
    
    @IBOutlet fileprivate weak var time: UILabel!
    
    @IBOutlet fileprivate weak var payment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // payButton.decorateForFurni()
        
        // self.contentView.drawTopBorderWithColor(UIColor.furniBrownColor(), height: 0.5)
    }
    
    func configureWithCart(_ cart: Cart, ad:String, ti:String, pa:String) {
        // Assign the labels.
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        totalItemsLabel.text = "\(cart.productCount()) Items"
        subtotalPriceLabel.text =  numberFormatter.string(from: NSNumber(value:Int((cart.subtotalAmount()))))! + "/="
        
        
        address.text = ad
        time.text = ti
        payment.text = pa
        
        //get delivery fee
        
        
        if ad.contains("Pick from Supermarket") {
            
            let feeRef = Database.database().reference().child("App Values")
            feeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                if snapshot.exists(){
                    print("SO THERE")
                    let val = snapshot.value as? [String: Any]
                    let v = val?["Service Fee"]
                    let serviceFee = Int(String(describing: v!))!
                    self.shippingPriceLabel.text = numberFormatter.string(from: NSNumber(value: serviceFee))! + "/="
                      self.feeTitle.text = "Service Fee:"
           self.totalPriceLabel.text = numberFormatter.string(from: NSNumber(value:Int((cart.totalAmount()+Float(serviceFee)))))! + "/="
                }
                else{
                    print("NOPE there")
                }
                
            })
            
        
            

    } else {
    
            //
            
            let userId = defaults.string(forKey: "userId")
            let usersRef = Database.database().reference().child("Users")
            let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
            var isExpress:Bool = false
            q.observeSingleEvent(of: .value, with: { DataSnapshot in
                if DataSnapshot.exists(){
                    
                    for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                        let userObject = users.value as? [String: AnyObject]
                        
                        guard    let ex = userObject?["expressExpiry"]  else{
                            return
                        }
                        
                        
                        if ex as! String == "" {
                            isExpress = false
                        }
                        else{
                              isExpress = true
                        }
                        
                    }
                    
                    if isExpress {
                        
                        self.shippingPriceLabel.text = "Free"
                        self.feeTitle.text = "Delivery Fee:"
                        self.totalPriceLabel.text = numberFormatter.string(from: NSNumber(value:Int((cart.totalAmount()))))! + "/="
                        
                        
                    } else {
                        
                        let feeRef = Database.database().reference().child("App Values")
                        feeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            
                            if snapshot.exists(){
                                print("SO THERE")
                                let val = snapshot.value as? [String: Any]
                                let v = val?["Delivery Fee"]
                                let deliveryFee = Int(String(describing: v!))!
                                self.shippingPriceLabel.text = numberFormatter.string(from: NSNumber(value: deliveryFee))! + "/="
                                self.totalPriceLabel.text = numberFormatter.string(from: NSNumber(value:Int((cart.totalAmount()+Float(deliveryFee)))))! + "/="
                                self.feeTitle.text = "Delivery Fee:"
                                //
                            }
                            else{
                                print("NOPE there")
                            }
                            
                        })
                        
                    }
                    
                }else{
                    print("User NOT There")
                }
            })
            
            
            //
            
  
          

    
    }
    
    }


}
