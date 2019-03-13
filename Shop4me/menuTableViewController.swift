//
//  menuTableViewController.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/13/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import Firebase

class menuTableViewController: UITableViewController {

    var menuItemList:[String] = ["PROFILE","Browse Products","Supermarkets","My Orders","Shop4me Express","Refer Friends","Contact Us"]
    
  
 
   // @IBOutlet weak var emailLabel: UILabel!
    //@IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

      //emailLabel.text = "simon@simon.com"
      //  nameLabel.text = "Peer Migw"
        
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)

  

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
        return 110
        }
        return 55
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCellToReturn = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        if indexPath.row == 0{
            let myCellToReturn = tableView.dequeueReusableCell(withIdentifier: "myCellProfile", for: indexPath) as! ProfileCell
       
            let defaults = UserDefaults.standard
            
                let email = defaults.string(forKey: "email")
            let fullname = defaults.string(forKey: "fullname")
            
            myCellToReturn.customerEmail.text = email
               myCellToReturn.customerName.text = fullname
            
            let imageView = myCellToReturn.profilePic
            
            let user = Auth.auth().currentUser
            if let filePath = Bundle.main.path(forResource: user?.photoURL?.absoluteString, ofType: "jpg"), let image = UIImage(contentsOfFile: filePath) {
                imageView?.contentMode = .scaleAspectFit
                imageView?.image = image
            }

               myCellToReturn.backgroundColor = UIColor.darkGray
        
        }
        else if indexPath.row == 1{
        let name = menuItemList[indexPath.row]
        myCellToReturn.textLabel?.text = name
        myCellToReturn.imageView?.image = UIImage(named: "ic_add_shopping_cart_white_48pt")
        }
            
        else if indexPath.row == 2{
            let name = menuItemList[indexPath.row]
            myCellToReturn.textLabel?.text = name
            myCellToReturn.imageView?.image = UIImage(named: "ic_store_white_48pt")
        }
        else if indexPath.row == 3{
            let name = menuItemList[indexPath.row]
            myCellToReturn.textLabel?.text = name
            myCellToReturn.imageView?.image = UIImage(named: "ic_description_white_48pt")
        }
        else if indexPath.row == 4{
            let name = menuItemList[indexPath.row]
            myCellToReturn.textLabel?.text = name
            myCellToReturn.imageView?.image = UIImage(named: "ic_card_membership_white_48pt")
        }
        else if indexPath.row == 5{
            let name = menuItemList[indexPath.row]
            myCellToReturn.textLabel?.text = name
            myCellToReturn.imageView?.image = UIImage(named: "ic_card_giftcard_white_48pt")
        }
        else if indexPath.row == 6{
            let name = menuItemList[indexPath.row]
            myCellToReturn.textLabel?.text = name
            myCellToReturn.imageView?.image = UIImage(named: "ic_call_white_48pt")
        }
    
        
        
        return myCellToReturn
    }
//54a2e2
    
  

    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var destinationVC: UIViewController!
       
        if indexPath.row == 0{
            destinationVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            destinationVC.title = "My Profile"
            changeColor (tableView: tableView, indexPath: indexPath)
        }
        
        if indexPath.row == 1{
            destinationVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
           // destinationVC.title = "Browse Products"
                changeColor (tableView: tableView, indexPath: indexPath)
        }
        
        if indexPath.row == 2{
           // myCell.backgroundColor = UIColor.red
            destinationVC = storyboard?.instantiateViewController(withIdentifier: "StoresViewController") as! StoresViewController
             changeColor (tableView: tableView, indexPath: indexPath)
        }
        else if indexPath.row == 3{
           // myCell.backgroundColor = UIColor.yellow
            
            //let defaults = UserDefaults.standard
          //  let userId = defaults.string(forKey: "userId")
          //  let fullname = defaults.string(forKey: "fullname")
          
            
           destinationVC = storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
            
            destinationVC.title = "My Orders"
            
             changeColor (tableView: tableView, indexPath: indexPath)
         
        }
        else if indexPath.row == 4{
            destinationVC = storyboard?.instantiateViewController(withIdentifier: "ExpressViewController") as! ExpressViewController
               destinationVC.title = "Shop4me Express"
              changeColor (tableView: tableView, indexPath: indexPath)
        }
        else if indexPath.row == 5{
            destinationVC = storyboard?.instantiateViewController(withIdentifier: "ReferFriendsViewController") as! ReferFriendsViewController
               destinationVC.title = "Refer Friends"
               changeColor (tableView: tableView, indexPath: indexPath)
        }

        else if indexPath.row == 6{
            destinationVC = storyboard?.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
               destinationVC.title = "Contact Us"
            changeColor (tableView: tableView, indexPath: indexPath)
        }
       
        sideMenuController()?.setContentViewController(destinationVC)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#43B02A")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func changeColor(tableView:UITableView, indexPath:IndexPath){
        let myc = hexStringToUIColor(hex: "#43B02A")
        let cell = tableView.cellForRow(at: indexPath)
        let selectedBackgroundView = UIView(frame: CGRect(x:0, y:0, width: cell!.frame.size.width, height:cell!.frame.size.height))
        
        selectedBackgroundView.backgroundColor = myc
        cell!.selectedBackgroundView = selectedBackgroundView
        

}
}
