//
//  SignUpViewController.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/14/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import Toast_Swift

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullnameTextField: UITextField!
    
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
        let BaseURL = MyVariables.BaseURL
      let defaults = UserDefaults.standard
    
    
    @IBOutlet weak var txtLabel: UILabel!
    
    
    @IBAction func createAccountAction(_ sender: UIButton) {
        
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else  if fullnameTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your full name", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }else  if addressTxt.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your full address", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else  if phoneTxt.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your phone number", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        else {
            //Show spinner
        self.view.makeToastActivity(.center)
            //create account
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
               
                    var ref: DatabaseReference!
                    ref = Database.database().reference().child("Users")
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    let nowDate = formatter.string(from: date)
                    
                    let inviteCode: String = self.generateInviteCode()
                    let email: String = self.emailTextField.text! as String
                    
                    let fullname: String = self.fullnameTextField.text! as String
                    let phone: String = self.phoneTxt.text! as String
                    let address: String = self.addressTxt.text! as String
                 
                    let changeRequest =  user?.createProfileChangeRequest()
                    changeRequest?.displayName = fullname
                    changeRequest?.commitChanges(completion: { (error) in
                        //
                    })
                    
                    //save user in firebase database
                    
                    let newUser = ["fullName": fullname,
                                "email": email,
                    "address": address, "userId": user?.uid, "phone1":phone,"phone2": "", "inviteCode": inviteCode, "createdAt": nowDate, "openCartId": "", "favoriteStore": "",  "expressExpiry":"", "loyaltyPoints":"0", "provider":"IOS", "referralCredit":"0"]
                    
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    let key = ref.childByAutoId().key
                    ref.child(key).setValue(newUser)
                    
                    let firstname = fullname.components(separatedBy: " ").first
                    let lastname = fullname.components(separatedBy: " ").last
                    
                    //create user in opencart db
                      let userUR = self.BaseURL+"create_user?firstname=\(firstname!)&lastname=\(lastname!)&email=\(email)&key=\(key)"
                    
                    let userURL = userUR.replacingOccurrences(of: " ", with: "%20")
                    Alamofire.request(userURL).responseString{ response in
                        if let JSON = response.result.value{
                            let openCartId = JSON as? String
                            let index = openCartId?.index((openCartId?.startIndex)!, offsetBy: 1)
                            let iid = openCartId?.substring(from: index!)
                            print(iid!)
                            self.saveOpenCartIdInFirabaseDB(id: iid!, userid: (user?.uid)!)
                            self.defaults.set(iid, forKey: "openCartId")
                        }
                    }
                    
                    //send welcomeemail
                    self.sendWelcomeEmail(email: email, names: fullname)
                    
                    //save user details on phone
                  
                    self.defaults.set(inviteCode, forKey: "inviteCode")
                    self.defaults.set(user?.uid, forKey: "userId")
                    self.defaults.set(email, forKey: "email")
                    self.defaults.set(fullname, forKey: "fullname")
                     self.defaults.set(key, forKey: "userKey")
               self.defaults.set(phone, forKey: "phone1")
                    self.defaults.set(address, forKey: "address")
                  
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideNavigationController")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func saveOpenCartIdInFirabaseDB(id:String, userid:String){
    
        let userId = userid
        let usersRef = Database.database().reference().child("Users")
        let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
        
        q.observeSingleEvent(of: .value, with: { DataSnapshot in
            if DataSnapshot.exists(){
                for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                    let userObject = users.value as? [String: AnyObject]
                    let   uKey = (users.key as? String)!

                        usersRef.child(uKey+"/openCartId").setValue(id)
                        // DataSnapshot.childSnapshot(forPath: uKey!).setValue(text, forKey: "school")
                   
                }
            }else{
                print("User NOT There")
            }
        })
        
    }
    
    func sendWelcomeEmail(email:String, names:String ){
        let userUR = self.BaseURL+"sendWelcomeEmail?email=\(email)&names=\(names)"
        let userURL = userUR.replacingOccurrences(of: " ", with: "%20")
        Alamofire.request(userURL).responseString{ response in
            if let JSON = response.result.value{
                
            }
        }
        
    }
    
    func generateInviteCode() -> String {
    let chars: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X",
    "Y","Z","0","1","2","3","4","5","6","7","8","9"]
        
        
        var code: String = ""
        
        for i in 0 ... 5 {
        
          code += chars[Int(arc4random_uniform(35))]
           
        }
    
    
    return code
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         scrollView.contentSize = CGSize(width: self.view.frame.width - 50, height: self.view.frame.height + 70)
        let nameImage = UIImageView(frame: CGRect(x:5 , y:0, width:20, height:20))
        nameImage.alpha = 0.5
        nameImage.image = UIImage(named: "man")
        let emailImage = UIImageView(frame: CGRect(x:5 , y:0, width:20, height:20))
 emailImage.alpha = 0.5
        emailImage.image = UIImage(named: "mail")
        let addressImage = UIImageView(frame: CGRect(x:5 , y:0, width:20, height:20))
     addressImage.alpha = 0.5
        addressImage.image = UIImage(named: "home")
        let phoneImage = UIImageView(frame: CGRect(x:5 , y:0, width:20, height:20))
          nameImage.alpha = 0.5
        phoneImage.image = UIImage(named: "telephone-call")
   phoneImage.alpha = 0.5
        let passwordImage = UIImageView(frame: CGRect(x:5 , y:0, width:20, height:20))
        passwordImage.alpha = 0.5
        passwordImage.image = UIImage(named: "unlocked")
        
        //Add Done Button on Keyboard
        
        emailTextField.leftViewMode = UITextFieldViewMode.always
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        fullnameTextField.leftViewMode = UITextFieldViewMode.always
        addressTxt.leftViewMode = UITextFieldViewMode.always
        phoneTxt.leftViewMode = UITextFieldViewMode.always
        
        emailTextField.leftView = emailImage
        passwordTextField.leftView = passwordImage
        fullnameTextField.leftView = nameImage
        addressTxt.leftView = addressImage
        phoneTxt.leftView = phoneImage
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        fullnameTextField.inputAccessoryView = toolbar
        addressTxt.inputAccessoryView = toolbar
        phoneTxt.inputAccessoryView = toolbar
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.tapFunction))
        txtLabel.isUserInteractionEnabled = true
        txtLabel.addGestureRecognizer(tap)
        
        
    }
    
    
    func tapFunction(sender:UITapGestureRecognizer) {
        let url = URL(string: "http://shop4me.co.ug/privacy")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
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
