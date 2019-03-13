//
//  StoresViewController.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/4/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Alamofire
import SDWebImage
import FirebaseStorage

class StoresViewController: UITableViewController {

    var storeList = [StoreModel]()
    
    let BaseURL = MyVariables.BaseURL+"all_stores"
    let BaseImageURL = MyVariables.BaseImageURL

    @IBOutlet var tableViewSubmitMethods: UITableView!
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    
    func cartButtonTapped(){
        
        let  pdVc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        pdVc.selectedIndex = 2
        self.navigationController?.pushViewController(pdVc, animated: true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load  from Opencart Db
        /*
        Alamofire.request(BaseURL).responseJSON{ response in
            if let JSON = response.result.value{
                let arr = JSON as? NSArray
                
                if arr!.count > 0 {
                    for i in 0 ... arr!.count - 1 {
                        
                        let prod = arr?[i] as? [String: Any]
                        let name = prod!["store_name"] as? String!
                        let desc =  prod!["store_description"] as? String!
                        let imageURL =  prod!["store_image"] as? String!
                      
                        
                        let p = StoreModel(name: name!,
                                             description:desc!,
                                             imageURL: imageURL!)
                        
                        self.storeList.append(p)
                        
                    }
                    self.tableView.reloadData()
                }
                
                
            }
            //   self.tableView.reloadData()
        }*/
        
        //Load from Firebase DB
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Stores")
        
        ref.observe(DataEventType.value, with: { (snaphot) in
            if snaphot.childrenCount > 0 {
                
                self.storeList.removeAll()
                
                for questions in snaphot.children.allObjects as! [DataSnapshot]{
                    let questionObject = questions.value as? [String: AnyObject]
                    let questionId = questions.key
                    let name = questionObject?["name"]
                    let branches = questionObject?["branches"]
                    let image = questionObject?["image"]
        
                    
                    let p = StoreModel(name: name! as! String,
                                       description:branches! as! String,
                                       imageURL: image! as! String)
                    
                    self.storeList.append(p)
                    
                }
                self.tableView.reloadData()
            }
        })
        
        let catItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Cart-Selected"), landscapeImagePhone: UIImage(named: "Cart-Selected"), style: .plain, target: self, action: #selector(StoresViewController.cartButtonTapped))
        catItem.tintColor = UIColor.white
        
        navigationItem.setRightBarButton(catItem, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeList.count + 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "submitCell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = "We currently support the following supermarkets and branches"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.detailTextLabel?.text = ""
            
        }
        
        if storeList.count > 0{
    
        for i in 1 ... storeList.count{
            
            if indexPath.row == i{
                
                let store: StoreModel
                store = storeList[indexPath.row - 1]
                cell.textLabel?.text = store.name
                cell.detailTextLabel?.text = store.description
                //let imageName = store.imageURL.components(separatedBy: "/")[1]
               // let imgURL = URL(string: BaseImageURL+imageName)
                //cell.imageView?.sd_setImage(with: imgURL)
                let storeRef:StorageReference
                let storage = Storage.storage()
                let storageRef = storage.reference()
                 storeRef = storageRef.child("Stores Images/"+store.imageURL)
                cell.imageView?.sd_setImage(with: storeRef)
                cell.setNeedsLayout()
                cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            }
        
        }
        }
        if indexPath.row == storeList.count + 1 {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = "Shop4me is an independent business that is not necessarily associated with, endorsed or sponsored by these retailers"
            if storeList.count > 0{
            cell.textLabel?.textColor = UIColor.gray
            cell.textLabel?.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16.0)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.detailTextLabel?.text = ""
            }
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
    }
    
}
