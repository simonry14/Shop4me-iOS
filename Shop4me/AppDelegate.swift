//
//  AppDelegate.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/13/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import Fabric
import TwitterKit
import FacebookLogin
import FirebaseDatabase
import Alamofire
import DropDown
import Toast_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let BaseURL = MyVariables.BaseURL
            let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //Disk persist firebase data
        FirebaseDatabase.Database.database().isPersistenceEnabled = true
        
        //Twitter Stuff
        Twitter.sharedInstance().start(withConsumerKey: "ZmFYFQJn57d79At26uC98DM9z", consumerSecret: "eQvbqoBvTbarHs5cJ4P7jZBA2lFhMDRrov6o2Lbjm8X3lkaxRY")
       // Fabric.with([Twitter.self])
    
      //Google things
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
       // GIDSignIn.sharedInstance().delegate = LoginSignupViewController.self as! GIDSignInDelegate
     
      
        // Add any custom logic here.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        DropDown.startListeningToKeyboard()
        
        return true
    }
    
    /*
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
     // ...
     return
     }
     // User is signed in
     // ...
     
     print("Firebase login with google succesful")
     
     //save user infirebase db
     var ref: DatabaseReference!
     ref = Database.database().reference().child("Users")
     let date = Date()
     let formatter = DateFormatter()
     formatter.dateFormat = "dd.MM.yyyy"
     let nowDate = formatter.string(from: date)
     
     let inviteCode: String = self.generateInviteCode()
     let email: String = (user?.email)!
     
     let fullname: String = (user?.displayName)!
     //save user in firebase database
     
     let newUser = ["fullName": fullname,
     "email": email,
     "address": "", "userId": user?.uid, "phone1":"","phone2": "", "inviteCode": inviteCode, "createdAt": nowDate, "openCartId": "", "favoriteStore": "",  "expressExpiry":"", "loyaltyPoints":"", "provider":"IOS"]
     
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
     }else {
     print("SAVING TO OPENCART FAILED")
     }
     }
     
     //send welcomeemail
     self.sendWelcomeEmail(email: (user?.email)!, names: (user?.displayName)!)
     
     //save user details on phone
     
     self.defaults.set(inviteCode, forKey: "inviteCode")
     self.defaults.set(user?.uid, forKey: "userId")
     self.defaults.set(email, forKey: "email")
     self.defaults.set(fullname, forKey: "fullname")
     self.defaults.set(key, forKey: "userKey")
     self.defaults.set("", forKey: "address")
     self.defaults.set("", forKey: "phone1")
     
     //Go to home controller
     let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
     let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController")
     self.window = UIWindow(frame:UIScreen.main.bounds)
     self.window?.rootViewController = vc
     self.window?.makeKeyAndVisible()
     
     
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
 
 */
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
          
            let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            
            
            GIDSignIn.sharedInstance().handle(url,
                                              sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                              annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            
             Twitter.sharedInstance().application(application, open: url, options: options)
            
            return handled
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}


