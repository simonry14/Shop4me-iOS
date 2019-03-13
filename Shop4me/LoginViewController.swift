//
//  LoginViewController.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/14/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift

class LoginViewController: UIViewController {

    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        if emailTxt.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else  if passwordTxt.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
            
        else {
            //Show spinner
            self.view.makeToastActivity(.center)
            
            Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed in")
                    let user = Auth.auth().currentUser
                    
                    let usersRef = Database.database().reference().child("Users")
                    
                    let q = usersRef.queryOrdered(byChild: "email").queryEqual(toValue: user?.email)
                    
                    q.observeSingleEvent(of: .value, with: { DataSnapshot in
                        
                        if DataSnapshot.exists(){
                            
                            //  let userData = DataSnapshot.value as! Dictionary<String, String>
                            
                            for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                                let userObject = users.value as? [String: AnyObject]
                                let inviteCode = userObject?["inviteCode"]
                                 let openCartId = userObject?["openCartId"]
                                 let address = userObject?["address"]
                                 let phone1 = userObject?["phone1"]
                                let key = users.key
                                
                                //save user details on phone
                                let defaults = UserDefaults.standard
                                defaults.set(inviteCode, forKey: "inviteCode")
                                defaults.set(user?.uid, forKey: "userId")
                                defaults.set(user?.email, forKey: "email")
                                defaults.set(user?.displayName, forKey: "fullname")
                                defaults.set(openCartId, forKey: "openCartId")
                                 defaults.set(address, forKey: "address")
                                 defaults.set(phone1, forKey: "phone1")
                                
                                defaults.set(key, forKey: "userKey")
                            defaults.synchronize()
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideNavigationController")
                                self.present(vc!, animated: true, completion: nil)
                            }
                        }
                    })

       
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                     self.view.hideToastActivity()
                }
            }
        }

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let emailImage = UIImageView(frame: CGRect(x:5 , y:0, width:20, height:20))
        emailImage.image = UIImage(named: "mail")
        let passwordImage = UIImageView(frame: CGRect(x:5 , y:0, width:20, height:20))
        passwordImage.image = UIImage(named: "unlocked")
        
        passwordTxt.leftViewMode = UITextFieldViewMode.always
        emailTxt.leftViewMode = UITextFieldViewMode.always
        
        emailTxt.leftView = emailImage
        passwordTxt.leftView = passwordImage

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        passwordTxt.inputAccessoryView = toolbar
        emailTxt.inputAccessoryView = toolbar

        
        // Do any additional setup after loading the view.
    }
    
    func doneClicked(){
        view.endEditing(true)
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
