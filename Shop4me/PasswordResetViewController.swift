//
//  PasswordResetViewController.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 7/1/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordResetViewController: UIViewController {
    
    @IBOutlet weak var msgLabel: UILabel!
    
    @IBOutlet weak var resetEmailTxt: UITextField!

    @IBOutlet weak var resetButton: UIButton!
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func resetButtonTapped(_ sender: Any) {
        
        if resetEmailTxt.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your registered email", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }else{
        Auth.auth().sendPasswordReset(withEmail: resetEmailTxt.text!, completion: { (error) in
            if let error = error {
            self.msgLabel.text = error.localizedDescription
                self.msgLabel.textColor = UIColor.red
            }else{
            self.loginButton.isHidden = false
            self.msgLabel.text = "Please check your email for password reset instructions"
                self.msgLabel.textColor = UIColor.green
            }
        })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
