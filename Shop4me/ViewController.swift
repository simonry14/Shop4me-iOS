//
//  ViewController.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/13/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase
import FirebaseStorage
import SDWebImage
import FirebaseStorageUI

class ViewController: UITabBarController {
    
    let BaseURL = MyVariables.BaseURL
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        
            toggleSideMenuView()
        
    }
    

    var userId:String?
    var fullname:String?
    var email:String?
    var userKey:String?

    //Get stored user details
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //

        
    let cartCount = Cart.sharedInstance.productCount()
        let favCount = Favorite.sharedInstance.favoriteCount()
        if cartCount != 0 {
self.tabBar.items?[2].badgeValue = String(cartCount)
        }
        if favCount != 0 {
        self.tabBar.items?[1].badgeValue = String(favCount)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

     // self.performSegue(withIdentifier: "QuestionDetailSegway", sender: Any?.self)
 
}

