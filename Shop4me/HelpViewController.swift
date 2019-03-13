//
//  HelpViewController.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/13/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit

class HelpViewController: UITableViewController {

    
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

        // Do any additional setup after loading the view.
        let catItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Cart-Selected"), landscapeImagePhone: UIImage(named: "Cart-Selected"), style: .plain, target: self, action: #selector(HelpViewController.cartButtonTapped))
        catItem.tintColor = UIColor.white
        
        navigationItem.setRightBarButton(catItem, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hcell", for: indexPath)
        
        if indexPath.row == 0{
            cell.textLabel?.text = "0777718828"
            cell.detailTextLabel?.text = "Call Us"
            cell.imageView?.image = UIImage(named: "call")
        }
        
        if indexPath.row == 1{
            cell.textLabel?.text = "0777718828"
            cell.detailTextLabel?.text = "Chat with us on WhatsApp"
            cell.imageView?.image = UIImage(named: "whatsapp")
            
        }
        
        if indexPath.row == 2{
            cell.textLabel?.text = "info@Shop4me.com"
            cell.detailTextLabel?.text = "Email Us"
            cell.imageView?.image = UIImage(named: "email")
        }
        
        if indexPath.row == 3{
            
            cell.textLabel?.text = "@Shop4me"
            cell.detailTextLabel?.text = "Tweet Us"
             cell.imageView?.image = UIImage(named: "twitter-1")
        }
        
        
        if indexPath.row == 4{
            
            cell.textLabel?.text = "www.facebook.com/Shop4me"
            cell.detailTextLabel?.text = "Send Us a Facebook Message"
            cell.imageView?.image = UIImage(named: "fb-art")
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            
            let url = URL(string: "tel://0777718828")!
            if #available(iOS 10.0, *){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        if indexPath.row == 1{
            let url = URL(string: "whatsapp://?app")!
            if #available(iOS 10.0, *){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        if indexPath.row == 2{
            let url = URL(string: "http://www.qnsnap.com/contact")!
            if #available(iOS 10.0, *){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
            UIApplication.shared.openURL(url)
            }
        }
        
        if indexPath.row == 3{
            let url = URL(string: "twitter://user?screen_name=simonry14")!
            if #available(iOS 10.0, *){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
      
        if indexPath.row == 4{
            let url = URL(string: "http://www.qnsnap.com/legal")!
            if #available(iOS 10.0, *){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        
    }


}
