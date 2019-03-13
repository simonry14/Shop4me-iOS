//
//  CheckoutViewController.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/18/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import DLRadioButton
import DropDown
import Alamofire
import FirebaseDatabase

class CheckoutViewController: UIViewController {
    
    var deliveryAddress: String = ""
    var deliveryTime: String = ""
    var paymentMethod: String = ""
    var iid:String = ""
    var savedAddress:String = ""
    
    @IBOutlet weak var deliveryTitle: UILabel!
    
    @IBOutlet weak var savedAddressButton: DLRadioButton!

    @IBAction func savedAddressButtonTapped(_ sender: Any) {
        pickFromStoreTxt.isHidden = true
        pickfromStoreLabel.isHidden = true
        addressTxt.isHidden = true
         payInStore.isHidden = true
           deliveryTitle.text = "Delivery Date & Time"
        mobileMoney.isEnabled = true
 address = savedAddress
        debitCard.isEnabled = true
        cod.isEnabled = true
           cod.isSelected = true
        payment = "Cash on Delivery"
        deliveryAddress = "saved"
      
        
    }
    
    @IBOutlet weak var newAddressButton: DLRadioButton!
    
    @IBAction func newAddressButtonTapped(_ sender: Any) {
        addressTxt.isHidden = false
        pickFromStoreTxt.isHidden = true
        pickfromStoreLabel.isHidden = true
         payInStore.isHidden = true
        deliveryTitle.text = "Delivery Date & Time"
        mobileMoney.isEnabled = true

        debitCard.isEnabled = true
        cod.isEnabled = true
        cod.isSelected = true
        payment = "Cash on Delivery"
        deliveryAddress = "new"
    }
    
    @IBOutlet weak var pickFromStore: DLRadioButton!
    
    @IBAction func pickFromStoreTapped(_ sender: Any) {
        pickFromStoreTxt.isHidden = false
         addressTxt.isHidden = true
      pickfromStoreLabel.text = ""
pickfromStoreLabel.isHidden = false
        payInStore.isHidden = false
        payInStore.isSelected = true
        mobileMoney.isEnabled = false

        debitCard.isEnabled = false
        cod.isEnabled = false
           deliveryTitle.text = "Pickup Date & Time"
        deliveryAddress = "pick"
        paymentMethod = "store"
      
       
    }
    
    @IBOutlet weak var asap: DLRadioButton!
    
    @IBAction func asapTapped(_ sender: Any) {
        specifyTimeTxt.isHidden = true
         deliveryTime = "asap"
    }
    
    @IBOutlet weak var nextDay: DLRadioButton!
    
   
    @IBAction func nextDayTapped(_ sender: Any) {
        specifyTimeTxt.isHidden = true
        deliveryTime = "nextday"
    }
    
    
    @IBOutlet weak var specifyTime: DLRadioButton!
    
    @IBAction func specifTimeTapped(_ sender: Any) {
        specifyTimeTxt.isHidden = false
        deliveryTime = "specify"
    }
    
    
    @IBOutlet weak var mobileMoney: DLRadioButton!
    
  
    @IBAction func mobileMoneyTapped(_ sender: Any) {
   
        paymentMethod = "mm"
        payment = "Mobile Money"
    }

    
    @IBOutlet weak var debitCard: DLRadioButton!
    

    @IBAction func debitCardTapped(_ sender: Any) {
     
        paymentMethod = "debit"
        payment = "Debit Card"
    }
    
    
    @IBOutlet weak var payInStore: DLRadioButton!
    
    
    @IBAction func payInStoreTapped(_ sender: Any) {
       
        paymentMethod = "store"
    }
    
    
    @IBOutlet weak var cod: DLRadioButton!
    
    @IBAction func codTapped(_ sender: Any) {
 
        paymentMethod = "cod"
        payment = "Cash on Delivery"
    }
    
    @IBOutlet weak var addressTxt: UITextField!
    
    @IBOutlet weak var pickfromStoreLabel: UILabel!
    @IBOutlet weak var pickFromStoreTxt: UIButton!
    
   
    @IBAction func pickFromStoreTxtTpped(_ sender: Any) {
          dropDown.show()
    }

    @IBOutlet weak var specifyTimeTxt: UITextField!
    

    
    let dropDown = DropDown()
    let BaseURL = MyVariables.BaseURL
    let defaults = UserDefaults.standard
    let myCart = Cart.sharedInstance.items
    var address = ""
    var telephone = ""
    var comment = ""
    var payment = ""
    var totalF = Cart.sharedInstance.totalAmount()
    var okayToPlaceOrder:Bool = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if address is there show it 

   savedAddress = defaults.string(forKey: "address")!
        if savedAddress != "" {
        savedAddressButton.setTitle(savedAddress, for: .normal)
        }
        
        let mmNumber = defaults.string(forKey: "phone1")
        if mmNumber != "" {
           
        }

        //default selected buttons
        savedAddressButton.isSelected = true
        asap.isSelected = true
        cod.isSelected = true
        
        //alignment
        savedAddressButton.contentHorizontalAlignment = .left
         newAddressButton.contentHorizontalAlignment = .left
         pickFromStore.contentHorizontalAlignment = .left
         asap.contentHorizontalAlignment = .left
         specifyTime.contentHorizontalAlignment = .left
         nextDay.contentHorizontalAlignment = .left
         mobileMoney.contentHorizontalAlignment = .left
         debitCard.contentHorizontalAlignment = .left
         cod.contentHorizontalAlignment = .left
         payInStore.contentHorizontalAlignment = .left
        
        pickFromStoreTxt.contentHorizontalAlignment = .left
         pickFromStoreTxt.sizeToFit()
        
        //hide all non essential views
        pickFromStoreTxt.isHidden = true
        addressTxt.isHidden = true
        specifyTimeTxt.isHidden = true
        payInStore.isHidden = true
        pickfromStoreLabel.isHidden = true
        
        
        //Dropdown
        //Get supported stores from Firebase
        var storeList = [String]()
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Stores")
        ref.observe(DataEventType.value, with: { (snaphot) in
            if snaphot.childrenCount > 0 {
                storeList.removeAll()
                
                for questions in snaphot.children.allObjects as! [DataSnapshot]{
                    let questionObject = questions.value as? [String: AnyObject]
                    let questionId = questions.key
                    let name = questionObject?["name"] as! String
                    let branches = questionObject?["branches"] as! String
                    let bArray = branches.components(separatedBy: ",")
                    for s in bArray{
                    let bName = name+", "+s+" Branch"
                        storeList.append(bName)
                    }
                   
                }
              
            }
            self.dropDown.dataSource = storeList
        })
        
        dropDown.anchorView = pickFromStoreTxt
        dropDown.dataSource = storeList
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x:0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = {[unowned self] (index:Int, item:String) in
                self.pickfromStoreLabel.text = item
            self.payment = "Pay in Supermarket: \(item)"
            self.address = "Pick from Supermarket: \(item)"
              self.okayToPlaceOrder = true
        }
        
        //set initial values
        
         deliveryAddress = "saved"
         deliveryTime = "asap"
         paymentMethod = "mm"
        
        payment = "Mobile Money"
        address = savedAddress //Change this to whatever address the nigga has saved
        comment = "As soon as possible"
        
        
        
        
        //Add Done Button on Keyboard
        addressTxt.leftViewMode = UITextFieldViewMode.always
        specifyTimeTxt.leftViewMode = UITextFieldViewMode.always
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        addressTxt.inputAccessoryView = toolbar
        specifyTimeTxt.inputAccessoryView = toolbar

    }
    
    func doneClicked(){
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func placeOrderTapped(_ sender: Any) {
        
        if deliveryAddress == "new"{
            
            if addressTxt.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your address", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
                okayToPlaceOrder = false
            }else{
            address = addressTxt.text!

            }
        }
        if deliveryAddress == "pick" {
            if pickfromStoreLabel.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please choose store from which to pick up your items", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
                   okayToPlaceOrder = false
            }else{
            address = "Pick from Supermarket: \(pickfromStoreLabel.text!)"
                 payment = "Pay in Supermarket: \(pickfromStoreLabel.text!)"

            }
        }
        if deliveryTime == "specify" {
            if specifyTimeTxt.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please specify date and time for your delivery or pickup", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
                   okayToPlaceOrder = false
            }else{
                comment = specifyTimeTxt.text!
            }
        }
        if paymentMethod == "mm" {
       
                payment = "Mobile Money"
            
        }
        
        if okayToPlaceOrder {
            let  pdVc = storyboard?.instantiateViewController(withIdentifier: "ReviewOrderViewController") as! ReviewOrderViewController
            pdVc.address = address
            pdVc.time = comment
            pdVc.payment = payment
            self.navigationController?.pushViewController(pdVc, animated: true)
       
        }
    }
   
}
