//
//  OrderSuccessfulViewController.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/18/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit

class OrderSuccessfulViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func viewOrdersTapped(_ sender: Any) {
        
        let  pdVc = storyboard?.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
        self.navigationController?.pushViewController(pdVc, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        let defaults = UserDefaults.standard
        
let fullname = defaults.string(forKey: "fullname")
        nameLabel.text = fullname?.components(separatedBy: "").first
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
