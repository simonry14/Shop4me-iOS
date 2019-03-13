//
//  InstapayViewController.swift
//  Shop4me
//
//  Created by mac on 8/4/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Toast_Swift

class InstapayViewController: UIViewController, UIWebViewDelegate {
    
    
    
    @IBOutlet weak var webViewy: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
 webViewy.delegate = self
        // Do any additional setup after loading the view.
        //Show spinner
        self.view.makeToastActivity(.center)
        let defaults = UserDefaults.standard
        let fullname = defaults.string(forKey: "fullname")
         let email = defaults.string(forKey: "email")
         let address = defaults.string(forKey: "address")
          let phone = defaults.string(forKey: "phone1")
        
        let userUR = "http://shop4me.co.ug/api/pay.html?name=\(fullname!)&email=\(email!)&phone=\(phone!)&address=\(address!)"
        let userURL = userUR.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: userURL)
        if let unwrappedURL = url {
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    self.webViewy.loadRequest(request)
                  self.webViewy.delegate = self
                }else {
                
                    print("ERROR: \(error)")
                }
            }
            task.resume()
        }
        webViewy.delegate = self
    }

    
    
     func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView.isLoading {
            // still loading
            return
        }
        
        print("finished")
        // finish and do something here
        self.view.hideToastActivity()
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
