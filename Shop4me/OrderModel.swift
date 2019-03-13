//
//  OrderModel.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/9/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import Foundation

class OrderModel {
    
    let orderId: Int
    let orderDate: String
    let orderTotal: String
    let orderStatus: String
    let paymentMethod: String
    let shippingAddress: String
    let time: String
    
    init(orderId: Int, orderDate: String, orderTotal: String, orderStatus: String, paymentMethod: String, shippingAddress: String, time: String) {
        self.orderId = orderId
        self.orderDate = orderDate
        self.orderTotal = orderTotal
        self.orderStatus = orderStatus
        self.paymentMethod = paymentMethod
        self.shippingAddress = shippingAddress
        self.time = time
    }
    
}
