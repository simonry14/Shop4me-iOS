//
//  StoreModel.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/9/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import Foundation
import UIKit

class StoreModel {
    
    let name: String
    let description: String
    let imageURL: String
    
    
    init(name: String, description: String, imageURL: String) {
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }
    
}
