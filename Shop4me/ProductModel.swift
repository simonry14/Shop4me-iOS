//
//  ProductModel.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/7/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import Foundation
import UIKit

class ProductModel: NSObject, NSCoding {
    
    var name: String
    var desc: String?
    var price: String
    var imageURL: String
    var id: Int?
       var quantity: Int?
    
    
    
    init(name: String, desc: String, price: String, imageURL: String, id: Int) {
        self.name = name
        self.desc = desc
        self.price = price
        self.imageURL = imageURL
        self.id = id
    }
    
    
    init(name: String, quantity: Int, price: String, imageURL: String) {
        self.name = name
        self.quantity = quantity
        self.price = price
        self.imageURL = imageURL
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let desc = aDecoder.decodeObject(forKey: "desc") as! String
          let price = aDecoder.decodeObject(forKey: "price") as! String
            let imageURL = aDecoder.decodeObject(forKey: "imageURL") as! String
        self.init( name: name, desc:desc, price:price, imageURL:imageURL, id: id as! Int)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imageURL, forKey: "imageURL")
    }
    
    
}
