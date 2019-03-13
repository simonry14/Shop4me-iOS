
//
//  ProfileViewController.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/27/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ProfileViewController: UITableViewController {

    
    @IBAction func menuTapped(_ sender: Any) {
           toggleSideMenuView()
    }
       let defaults = UserDefaults.standard
    var school:String?
    var course:String?
    var level:String?
    
    @IBAction func LogoutButtonTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            let defaults = UserDefaults.standard
            defaults.set("", forKey: "inviteCode")
            defaults.set("", forKey: "userId")
            defaults.set("", forKey: "email")
            defaults.set("", forKey: "fullname")
            defaults.set("", forKey: "userKey")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginSignupViewController")
            self.present(vc!, animated: true, completion: nil)
            
        }
        catch let error as NSError {
        
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pcell", for: indexPath)
           let userId = defaults.string(forKey: "userId")
        let email = defaults.string(forKey: "email")
         let name = defaults.string(forKey: "fullname")

        if indexPath.row == 0{
          cell.textLabel?.text = "Name"
          cell.detailTextLabel?.text = name
        }
        
        if indexPath.row == 1{
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.text = email
        }
        
        if indexPath.row == 2{
            
            
      
            let usersRef = Database.database().reference().child("Users")
            let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
            
            q.observeSingleEvent(of: .value, with: { DataSnapshot in
                if DataSnapshot.exists(){
                    
                    for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                        let userObject = users.value as? [String: AnyObject]
                        
                        self.school = userObject?["phone1"] as! String
                       cell.textLabel?.text = "Phone Number 1"
                       cell.detailTextLabel?.text = self.school
                        
                    }
                }else{
                    print("User NOT There")
                }
            })
            
            
        }
        
        if indexPath.row == 3{
            
           
            let usersRef = Database.database().reference().child("Users")
            let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
            
            q.observeSingleEvent(of: .value, with: { DataSnapshot in
                if DataSnapshot.exists(){
                    
                    for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                        let userObject = users.value as? [String: AnyObject]
                        self.level = userObject?["phone2"] as! String
                        
                        cell.textLabel?.text = "Phone Number 2"
                       cell.detailTextLabel?.text = self.level
                    }
                }else{
                    print("User NOT There")
                }
            })
            
            
        }
        
        if indexPath.row == 4{
           
            let usersRef = Database.database().reference().child("Users")
            let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
            
            q.observeSingleEvent(of: .value, with: { DataSnapshot in
                if DataSnapshot.exists(){
                    
                    for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                        let userObject = users.value as? [String: AnyObject]
                        self.course = userObject?["address"] as! String
                        
                        cell.textLabel?.text = "Address"
                        cell.detailTextLabel?.text = self.course
                    }
                }else{
                    print("User NOT There")
                }
            })
            
           
        }
        if indexPath.row == 5{
            let usersRef = Database.database().reference().child("Users")
            let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
            
            q.observeSingleEvent(of: .value, with: { DataSnapshot in
                if DataSnapshot.exists(){
                    
                    for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                        let userObject = users.value as? [String: AnyObject]
                        self.course = userObject?["favoriteStore"] as! String
                        
                        cell.textLabel?.text = "Favorite Store"
                        cell.detailTextLabel?.text = self.course
                    }
                }else{
                    print("User NOT There")
                }
            })
            
            
        }
        
        if indexPath.row == 6{
            let userId = defaults.string(forKey: "userId")
            let usersRef = Database.database().reference().child("Users")
            let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
            
            q.observeSingleEvent(of: .value, with: { DataSnapshot in
                if DataSnapshot.exists(){
                    
                    for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                        let userObject = users.value as? [String: AnyObject]
                        self.course = userObject?["loyaltyPoints"] as! String
                        
                       cell.textLabel?.text = "Loyalty Card Points"
                        cell.detailTextLabel?.text = self.course
                    }
                }else{
                    print("User NOT There")
                }
            })
            
            
        }
        
        if indexPath.row == 6{
            let userId = defaults.string(forKey: "userId")
            let usersRef = Database.database().reference().child("Users")
            let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
            
            q.observeSingleEvent(of: .value, with: { DataSnapshot in
                if DataSnapshot.exists(){
                    
                    for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                        let userObject = users.value as? [String: AnyObject]
                        self.course = userObject?["referralCredit"] as! String
                        
                        cell.textLabel?.text = "Referral Credit"
                        cell.detailTextLabel?.text = self.course
                    }
                }else{
                    print("User NOT There")
                }
            })
            
            
        }

        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)
       // qnName =  currentCell.questionName.text
    
        if indexPath.row == 2{
          let title =  currentCell?.textLabel?.text
          let detail =  currentCell?.detailTextLabel?.text
            presentAlert(mtitle: title!, row: 2, cell:currentCell!)
          
        }
        
        if indexPath.row == 3{
            let title =  currentCell?.textLabel?.text
            let detail =  currentCell?.detailTextLabel?.text
            presentAlert(mtitle: title!, row: 3, cell:currentCell!)
           
        }

        if indexPath.row == 4{
            let title =  currentCell?.textLabel?.text
            let detail =  currentCell?.detailTextLabel?.text
            presentAlert(mtitle: title!, row: 4, cell:currentCell!)
            
        }
        
        if indexPath.row == 5{
            let title =  currentCell?.textLabel?.text
            let detail =  currentCell?.detailTextLabel?.text
            presentAlert(mtitle: title!, row: 5, cell:currentCell!)
        }
        
        self.tableView.reloadData()
    }

    
    func presentAlert(mtitle:String, row:Int, cell:UITableViewCell) {
        let alertController = UIAlertController(title: mtitle, message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                let text = field.text!
                    self.saveText(text: text, row: row)
                //update cellwith new data
                cell.detailTextLabel?.text = text
            } else {
                // user did not fill field
                print("empty")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = ""
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func saveText(text:String, row:Int){
       
        let userId = defaults.string(forKey: "userId")
        let usersRef = Database.database().reference().child("Users")
        let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
        
        q.observeSingleEvent(of: .value, with: { DataSnapshot in
            if DataSnapshot.exists(){
                for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                   let userObject = users.value as? [String: AnyObject]
                  let   uKey = (users.key as? String)!
                    
                    
                    if row == 2 {
                        usersRef.child(uKey+"/phone1").setValue(text)
                        self.defaults.set(text, forKey: "phone1")
                        self.defaults.synchronize()
                    }
                    
                    if row == 3 {
                         usersRef.child(uKey+"/phone2").setValue(text)
                        self.defaults.set(text, forKey: "phone2")
                         self.defaults.synchronize()                    }
                    
                    if row == 4 {
                          usersRef.child(uKey+"/address").setValue(text)
                       self.defaults.set(text, forKey: "address")
                         self.defaults.synchronize()                    }
                    if row == 5 {
                        usersRef.child(uKey+"/favoriteStore").setValue(text)
                         self.defaults.synchronize()                    }
                }
            }else{
                print("User NOT There")
            }
        })
    
    }
}
