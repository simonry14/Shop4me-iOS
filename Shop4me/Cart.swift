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

import Foundation
//import Crashlytics

final class Cart {
    static let sharedInstance = Cart()
  var userDefaults = UserDefaults.standard
    //static let cartUpdatedNotificationName = "xyz.furni.cart.updated.notification"

   // var items: [CartItem] = []
    
    var items: [CartItem] = []

    init() {
        readCartFromDisk()
    }

    init(items: [CartItem]) {
        self.items = items
        
    }
    
    func readCartFromDisk() {
        guard let decoded  = userDefaults.object(forKey: "cart") as! Data? else {
            self.items = []
            return
        }
        guard let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [CartItem]? else {
            self.items = []
            return
        }
       self.items = decodedTeams
  
    }
    
    func saveCartToDisk(){

        
      
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: items)
        userDefaults.set(encodedData, forKey: "cart")
        userDefaults.synchronize()
    }

    func productCount() -> Int {
        var count = 0
        for item in items {
            count += item.quantity
        }
        return count
    }

    func subtotalAmount() -> Float {
        return items.map { $0.price }.reduce(0, +)
    }

    func shippingAmount() -> Float {
        return 0
    }

    func totalAmount() -> Float {
        return subtotalAmount() + shippingAmount()
    }

    func addProduct(_ product: ProductModel) {
        // Check if the product is already part of the cart.
        let existingCartItem = items.filter { $0.product.id == product.id }.first //check if product is already in cart

        if let existingCartItem = existingCartItem {
            if existingCartItem.quantity < 100 { //if the quantity of product is less than 100, increment it by one
                existingCartItem.quantity += 1
            }
        } else { // else if product isnt in cart, add it to cart
            items.append(CartItem(product: product))
        }


      //saveupdated cart to disk
        saveCartToDisk()
    }
    
    
    func reduceProduct(_ product: ProductModel) {
        // Check if the product is already part of the cart.
        let existingCartItem = items.filter { $0.product.id == product.id }.first //check if product is already in cart
        
        if let existingCartItem = existingCartItem {
            if existingCartItem.quantity > 0 { //if the quantity of product is greater than 0
                existingCartItem.quantity -= 1
            }
        } else { // else if product is 0 remoove it from cart
             items = items.filter { $0.product.id != product.id }
        }
        

        //saveupdated cart to disk
        saveCartToDisk()
    }
    
    func isProductInCart( product: ProductModel) -> Bool{
     let existingCartItem = items.filter { $0.product.id == product.id }.first
        var isIn:Bool
        if existingCartItem != nil {
          isIn = true
           
        } else {
        isIn = false
        }
        return isIn
    }
    
    func quantityOfThisProductInCart(product: ProductModel) -> Int{
    
        let existingCartItem = items.filter { $0.product.id == product.id }.first
        return (existingCartItem?.quantity)!
        
    }
    

    func removeProduct(_ product: ProductModel) {
        items = items.filter { $0.product.id != product.id }
          saveCartToDisk()
    }

    func isEmpty() -> Bool {
        return productCount() == 0
    }

    func reset() {
        items = []
      saveCartToDisk()
    }

    //fileprivate func postCartUpdatedNotification() {
    //    NotificationCenter.default.post(name: Notification.Name(rawValue: Cart.cartUpdatedNotificationName), object: self)
    //}
}
