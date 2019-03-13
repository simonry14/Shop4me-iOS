//
//  LoginSignupViewController.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/14/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore
import TwitterKit
import FBSDKCoreKit
import Firebase
import Alamofire
import Toast_Swift

class LoginSignupViewController: UIViewController , GIDSignInUIDelegate, LoginButtonDelegate, GIDSignInDelegate{
    

    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    let BaseURL = MyVariables.BaseURL
    
    @IBAction func googleButton(_ sender: GIDSignInButton) {
        
            GIDSignIn.sharedInstance().signIn()
    }
        let defaults = UserDefaults.standard
    
    var inviteCode:String?
    var uKey:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupBtn.isHidden = true
        loginBtn.isHidden = true

//check if there's a user signed in
        if Auth.auth().currentUser != nil{
            //user is sined in so go to home viewcontroller
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideNavigationController")
            self.present(vc!, animated: true, completion: nil)
        }
        else{
            setupTopLabel()
        setUpFacebookButton()
        setUpGoogleButton()
        setUpTwitterButton()
            signupBtn.isHidden = false
            loginBtn.isHidden = false
       }
    }
    
    func loginButtonDidLogout (){
    
    }
   
    fileprivate func setUpTwitterButton(){
        let twitterButton = TWTRLogInButton{(session, error) in
            if let err = error{
                return
            }
        //Successful
            
            print("Twitter Login sucessful")
            //send stuff to firebase
            guard let token = session?.authToken else {return}
            guard let secret = session?.authTokenSecret else {return}
            let credential = TwitterAuthProvider.credential(withToken: token, secret: secret)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    // ...
                    return
                }
                // User is signed in
                // ...
                print("Firebase login with twiiter succesful")
                //save user in fb db
                var user = Auth.auth().currentUser
                self.saveNewUserInFirebaseDatabase()
            }
        }
        view.addSubview(twitterButton)
        twitterButton.frame = CGRect(x: 16, y: 116 + 66 + 66, width: view.frame.width - 32 , height: 50)
        
        let txtLabel = UILabel()
        txtLabel.text = "By continuing you accept our terms and privacy policy"
        txtLabel.numberOfLines = 0
        txtLabel.lineBreakMode = .byWordWrapping
txtLabel.textColor = UIColor.blue
        txtLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(txtLabel)
        txtLabel.frame = CGRect(x: 16, y: 116 + 66 + 66 + 66, width: view.frame.width - 32 , height: 50)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginSignupViewController.tapFunction))
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
    
    fileprivate func setUpGoogleButton(){
        let googleButton = GIDSignInButton()
        view.addSubview(googleButton)
        googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32 , height: 55)
        googleButton.colorScheme = GIDSignInButtonColorScheme.dark
        googleButton.style = GIDSignInButtonStyle.wide
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    fileprivate func setUpFacebookButton(){
        
        
        
        let facebookButton = LoginButton(readPermissions: [ .publicProfile ])
        view.addSubview(facebookButton)
        facebookButton.frame = CGRect(x: 16, y: 116 , width: view.frame.width - 32 , height: 50)
        facebookButton.delegate = self
      
    }
    
    
    func setupTopLabel(){
        let txtLabel = UILabel()
        txtLabel.text = "Welcome to Shop4me™"
        txtLabel.numberOfLines = 0
        txtLabel.lineBreakMode = .byWordWrapping
        txtLabel.textColor = UIColor.black
        txtLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(txtLabel)
        txtLabel.frame = CGRect(x: 16, y: 20, width: view.frame.width - 32 , height: 30)
        
        let img = UIImageView()
        img.image = UIImage(named: "s4m")
        view.addSubview(img)
        img.frame = CGRect(x: view.frame.width - 100 , y: 20, width: 80 , height: 80)
        
        
        
    }
    
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    //FACEBOOK
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
            var user  = Auth.auth().currentUser
            self.saveNewUserInFirebaseDatabase()
        }
    }
    
    //GOOGLE
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            //failed
            return
        }
        //success
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                return
            }
            // User is signed in
            print("Firebase login with google succesful")
            self.saveNewUserInFirebaseDatabase()
        }
    }
    

    
    func saveNewUserInFirebaseDatabase(){
        //Show spinner
        self.view.makeToastActivity(.center)
        var user =  Auth.auth().currentUser
        //save user infirebase db
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Users")
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let nowDate = formatter.string(from: date)
        
        inviteCode = self.generateInviteCode()
        guard    let email: String = (user!.email)! else {
        let email = ""
        }
        
        let fullname: String = (user!.displayName)!
        //save user in firebase database
        
        let newUser = ["fullName": fullname,
                       "email": email,
                       "address": "", "userId": user?.uid, "phone1":"","phone2": "", "inviteCode": inviteCode!, "createdAt": nowDate, "openCartId": "", "favoriteStore": "",  "expressExpiry":"", "loyaltyPoints":"", "provider":"IOS", "referralCredit":"0"]
        
        //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
        
        uKey = ref.childByAutoId().key
        ref.child(uKey!).setValue(newUser)
        
        let firstname = fullname.components(separatedBy: " ").first
        let lastname = fullname.components(separatedBy: " ").last
        
        //create user in opencart db
        let userUR = self.BaseURL+"create_user?firstname=\(firstname!)&lastname=\(lastname!)&email=\(email)&key=\(uKey!)"
        
        let userURL = userUR.replacingOccurrences(of: " ", with: "%20")
        Alamofire.request(userURL).responseString{ response in
            if let JSON = response.result.value{
                let openCartId = JSON as? String
                let index = openCartId?.index((openCartId?.startIndex)!, offsetBy: 1)
                let iid = openCartId?.substring(from: index!)
                print(iid!)
                self.saveOpenCartIdInFirabaseDB(id: iid!, userid: (user?.uid)!)
                self.defaults.set(iid, forKey: "openCartId")
                self.defaults.synchronize()
            } else {
                print ("OPENCART USER CREATION FAILED")
            }
        }
        
        
        
        //send welcomeemail
        sendWelcomeEmail(email: (user?.email)!, names: (user?.displayName)!)
        
        //save user details on phone
        defaults.set(inviteCode!, forKey: "inviteCode")
        defaults.set(user?.uid, forKey: "userId")
        defaults.set(user?.email, forKey: "email")
        defaults.set(user?.displayName, forKey: "fullname")
        defaults.set(uKey!, forKey: "userKey")
        defaults.set("", forKey: "address")
        defaults.set("", forKey: "phone1")
        
        
        //Go to home controller
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideNavigationController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    func saveOpenCartIdInFirabaseDB(id:String, userid:String){
        var userId = userid
        let usersRef = Database.database().reference().child("Users")
        let q = usersRef.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
        q.observeSingleEvent(of: .value, with: { DataSnapshot in
            if DataSnapshot.exists(){
                for users in DataSnapshot.children.allObjects as! [DataSnapshot]{
                    let userObject = users.value as? [String: AnyObject]
                    let   uKey = (users.key as? String)!
                    
                    usersRef.child(uKey+"/openCartId").setValue(id)

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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
