//
//  FavoriteViewController.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/13/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import Toast_Swift

final class FavoriteViewController: UITableViewController {

 fileprivate let fav = Favorite.sharedInstance
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var productList = [ProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Put a label as the background view to display when the cart is empty.
        let emptyCartLabel = UILabel()
        emptyCartLabel.numberOfLines = 0
        emptyCartLabel.textAlignment = .center
        //      emptyCartLabel.textColor = UIColor.furniDarkGrayColor()
        emptyCartLabel.font = UIFont.systemFont(ofSize: CGFloat(20))
        emptyCartLabel.text = "Products you save as favorites will appear here.   \nTo add products to your favorites just tap the 💛 button next to it."
        
        tableView.backgroundView = emptyCartLabel
        tableView.backgroundView?.isHidden = true
        tableView.backgroundView?.alpha = 0
      tableView.separatorStyle  = .none
        self.tabBarItem.badgeValue = String(Favorite.sharedInstance.favoriteCount())
 self.parent?.title = "Favorite Products"
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.title = "Favorite Products"
        self.tableView.reloadData()
        toggleEmptyCartLabel()
    }
    
    
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fav.isEmpty() ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the cart.
        return fav.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myfavoriteproductcell", for: indexPath) as! FavoriteProductItemCell
        
        // Find the corresponding cart item.
        let prodId = fav.items[indexPath.row]
        
        // Keep a weak reference on the table view.
        cell.cartItemQuantityChangedCallback = { [unowned self] in
            self.refreshCartDisplay()
        self.tableView.reloadData()
        }
        
        // Configure the cell with the cart item.
     cell.configureWithFavoriteProduct(prodId)
        self.tabBarItem.badgeValue = String(Favorite.sharedInstance.favoriteCount())
        
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(FavoriteViewController.favoriteButtonTapped), for: UIControlEvents.touchUpInside)
        
        cell.addToCartButton.tag = prodId
        cell.addToCartButton.addTarget(self, action: #selector(FavoriteViewController.addToCartButton), for: UIControlEvents.touchUpInside)
        
        // Return the cart item cell.
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Remove this item from the cart and refresh the table view.
        fav.items.remove(at: indexPath.row)
        
        // Either delete some rows within the section (leaving at least one) or the entire section.
        if fav.items.count > 0 {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        }
        
        self.tabBarItem.badgeValue = String(Favorite.sharedInstance.favoriteCount())
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    

    
    fileprivate func refreshCartDisplay() {
        let cartTabBarItem = self.parent!.tabBarItem
        
        // Update the tab bar badge.
        let productCount = fav.favoriteCount()
        cartTabBarItem!.badgeValue = productCount > 0 ? String(productCount) : nil
        
        // Update the tab bar icon.
        if productCount > 0 {
            cartTabBarItem?.image = UIImage(named: "Cart-Full")
            cartTabBarItem?.selectedImage = UIImage(named: "Cart-Full-Selected")
        } else {
            cartTabBarItem?.image = UIImage(named: "Cart")
            cartTabBarItem?.selectedImage = UIImage(named: "Cart-Selected")
        }
        
        // Toggle the empty cart label if needed.
        toggleEmptyCartLabel()
    }
    
    fileprivate func toggleEmptyCartLabel() {
        if fav.isEmpty() {
            UIView.animate(withDuration: 0.15, animations: {
                self.tableView.backgroundView!.isHidden = false
                self.tableView.backgroundView!.alpha = 1
                  self.tabBarItem.badgeValue = nil
            })
        } else {
            UIView.animate(withDuration: 0.15,
                           animations: {
                            self.tableView.backgroundView!.alpha = 0
            },
                           completion: { finished in
                            self.tableView.backgroundView!.isHidden = true
            }
            )
        }
    }
    
    func favoriteButtonTapped(_ sender: UIStepper) {
        let p = Favorite.sharedInstance.items[sender.tag]
        let IP:  IndexPath = IndexPath(row: sender.tag, section: 0)
        let cellWhosefavoriteButtonwasClicked = tableView.cellForRow(at: IP) as! FavoriteProductItemCell
        
        if Favorite.sharedInstance.isProductFavorite(productId: p) {
            cellWhosefavoriteButtonwasClicked.favoriteButton.setImage(UIImage.favoriteImageForFavoritedState(false), for: UIControlState())
            Favorite.sharedInstance.removeProduct(p)
            tableView.reloadData()
        }else{
            cellWhosefavoriteButtonwasClicked.favoriteButton.setImage(UIImage.favoriteImageForFavoritedState(true), for: UIControlState())
            Favorite.sharedInstance.addProduct(p)
        }
        
        
        
        
        //  let favorite = !self.favorited
        // self.favorited = favorite
        
    }
    
    
    func addToCartButton(_ sender: UIStepper) {
        let id = sender.tag
        //let p = FavoriteProducts.sharedInstance.items[ind]
        let p = getProductFromFavListGivenId(iid:id)
            Cart.sharedInstance.addProduct(p)
        self.view.makeToast(p.name + " added to cart", duration: 2.0, position: .center)
        let tabC = self.parent as? UITabBarController
        tabC?.tabBar.items?[2].badgeValue = String(Cart.sharedInstance.productCount())
        

}
    
    func getProductFromFavListGivenId(iid:Int) -> ProductModel {
        var pr:ProductModel?
        for p in FavoriteProducts.sharedInstance.items {
            if p.id == iid{
            pr = p
            }
        }
    return pr!
    }
}
