//
//  ExpressViewController.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/5/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ExpressViewController: UIViewController {
    
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    func cartButtonTapped(){
        
        let  pdVc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        pdVc.selectedIndex = 2
        self.navigationController?.pushViewController(pdVc, animated: true)
        
        
    }
    
    @IBOutlet weak var joinButton: UIButton!
    
    
    @IBAction func joinButtonTapped(_ sender: Any) {
        
    }
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var feeLabel: UILabel!
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feeRef = Database.database().reference().child("App Values")
        feeRef.observeSingleEvent(of: .value, with: { (snapshot) in
          
            
            if snapshot.exists(){
                print("SO THERE")
            let val = snapshot.value as? [String: Any]
                let v = val?["Express Amount"]
                self.feeLabel.text = String(describing: v!) + "/="
            }
            else{
                print("NOPE there")
            }
            
        })
    

        // LETS TRY THIS
        
        let userId = defaults.string(forKey: "userId")
        let usersRef = Database.database().reference().child("Users")
        let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
        
        q.observeSingleEvent(of: .value, with: { DataSnapshot in
            if DataSnapshot.exists(){
                
                for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                    let userObject = users.value as? [String: AnyObject]
                    
                    guard    let ex = userObject?["expressExpiry"]  else{
                    return
                    }
                    
                    
                    if ex as! String == "" {
                        print("not there")
                        self.topLabel.text = "Get free unlimited deliveries for a full year for just"
                    }
                    else{
                        self.topLabel.text = "Your Express membership expires on"
                        self.feeLabel.text = ex as! String
                        self.joinButton.isHidden = true
                    }
                 
                }
            }else{
                print("User NOT There")
            }
        })
        
        let catItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Cart-Selected"), landscapeImagePhone: UIImage(named: "Cart-Selected"), style: .plain, target: self, action: #selector(ExpressViewController.cartButtonTapped))
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
