//
//  Favorite.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/13/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import Foundation

final class Favorite {
    static let sharedInstance = Favorite()
    var userDefaults = UserDefaults.standard
    //static let cartUpdatedNotificationName = "xyz.furni.cart.updated.notification"
    
    // var items: [CartItem] = []
    
    var items: [Int] = []
    
    init() {
        readFavoriteFromDisk()
    }
    
    init(items: [Int]) {
        self.items = items
        
    }
    
    func readFavoriteFromDisk() {
        guard let decoded  = userDefaults.object(forKey: "favorites") as! Data? else {
            self.items = []
            return
        }
        guard let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Int]? else {
            self.items = []
            return
        }
        self.items = decodedTeams
        
    }
    
    func saveFavoritesToDisk(){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: items)
        userDefaults.set(encodedData, forKey: "favorites")
        userDefaults.synchronize()
    }
    
    func favoriteCount() -> Int {
        return items.count
    }
    
    
    func addProduct(_ productId: Int) {
        items.append(productId)
        saveFavoritesToDisk()
        readFavoriteFromDisk()
    }
    
    
    func isProductFavorite( productId: Int) -> Bool{
      return  items.contains(productId)
    
    }
    
    
    func removeProduct(_ productId: Int) {

        items = items.filter { $0 != productId }
         saveFavoritesToDisk()
        readFavoriteFromDisk()
    }
    
    func isEmpty() -> Bool {
        return favoriteCount() == 0
    }
    
    func reset() {
        items = []
          saveFavoritesToDisk()
    }
    
}
