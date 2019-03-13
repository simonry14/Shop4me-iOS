//
//  ReferFriendsViewController.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/5/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit

class ReferFriendsViewController: UIViewController {

    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBAction func shareButton(_ sender: UIButton) {
        let defaults = UserDefaults.standard
         let inviteCode = defaults.string(forKey: "inviteCode")
        let activityViewController = UIActivityViewController(activityItems:
            ["Check out Shop4me, get groceries delivered to your door step in 1 hour. Use code \(inviteCode!) to get 5,000/= credit. www.shop4me.co.ug"], applicationActivities: nil)
        let excludeActivities = [
            UIActivityType.message,
            UIActivityType.mail,
            UIActivityType.print,
            UIActivityType.copyToPasteboard,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.airDrop]
        activityViewController.excludedActivityTypes = excludeActivities;
        
        present(activityViewController, animated: true,
                              completion: nil)
    }
    
    func cartButtonTapped(){
        
        let  pdVc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        pdVc.selectedIndex = 2
        self.navigationController?.pushViewController(pdVc, animated: true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let code = defaults.string(forKey: "inviteCode")
        codeLabel.text = code
        topLabel.numberOfLines = 0
//topLabel.sizeToFit()
        topLabel.lineBreakMode = .byWordWrapping
        // Do any additional setup after loading the view.
        
        let catItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Cart-Selected"), landscapeImagePhone: UIImage(named: "Cart-Selected"), style: .plain, target: self, action: #selector(ReferFriendsViewController.cartButtonTapped))
        catItem.tintColor = UIColor.white
        
        navigationItem.setRightBarButton(catItem, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
