//
//  ShopCollectionViewController.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/5/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class ShopCollectionViewController: UICollectionViewController {

    var catTitle:String?
    var catURL:String?
    var catNo:Int?

    @IBOutlet var MyCollView: UICollectionView!
        
        var imagesArr = ["milk","fruits", "bakery", "soft drinks", "rice","cereal", "snacks", "meatand fish","beauty", "baby", "beer", "seasoning" ]
        
        var namesArr = ["Dairy & Eggs","Fruits & Vegetables", "Bakery", "Soft Drinks", "Rice & Pasta","Breakfast Goodies", "Snacks & Candies", "Meats & Seafood","Health & Beauty", "Baby Items", "Alcohol", "Pantry" ]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            self.MyCollView.delegate = self
            self.MyCollView.dataSource = self
            

            
            //let tableViewHeight = UIScreen.main.bounds.height - tableView.frame.origin.y - tabBarController!.tabBar.bounds.height - 40

            
            // Register cell classes
         //   self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
            
            // Do any additional setup after loading the view.
            //self.parent?.title = "Browse Products"
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.title = ""
       
    }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using [segue destinationViewController].
         // Pass the selected object to the new view controller.
         }
         */
        
        
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return imagesArr.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!MyCollectionViewCell
            cell.imgView.image = UIImage(named: imagesArr[indexPath.row])
            cell.catName.text = namesArr[indexPath.row]
            cell.catName.numberOfLines = 0
            cell.catName.lineBreakMode = .byWordWrapping
            //cell.catName.sizeToFit()
            // Configure the cell
            
            return cell
        }
    

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
         catTitle = namesArr[indexPath.row]
        catNo = indexPath.row
        self.performSegue(withIdentifier: "CategorySegue", sender: self)
        
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategorySegue"{
           
         let cVc : CategoryViewController = segue.destination as! CategoryViewController
            cVc.title = catTitle!
cVc.ctId = catNo!
            
    
           
            
        }
    }
    
    
}
