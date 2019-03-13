//
//  FavoriteProducts.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/14/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import Foundation

final class FavoriteProducts {
    static let sharedInstance = FavoriteProducts()

    
    var items: [ProductModel] = []
    
    init() {
        }
    
    init(items: [ProductModel]) {
        self.items = items
}
}
