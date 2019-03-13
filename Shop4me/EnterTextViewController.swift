//
//  EnterTextViewController.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/19/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EnterTextViewController: UIViewController {

    @IBOutlet weak var subject: UITextField!
    
    @IBOutlet weak var questionText: UITextView!
    @IBAction func sendQuestionButton(_ sender: Any) {
        
        
        if subject.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter a subject", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else  if questionText.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your question", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
            
        else {
            
            //Get stored user details
            var defaults = UserDefaults.standard
            
            let userId = defaults.string(forKey: "userId")
            var questionNumber = defaults.string(forKey: "questionNumber")
            if questionNumber != nil {
               
                var   SquestionNumber = Int(questionNumber!)! + 1
                questionNumber = String(SquestionNumber)
                
            }else{
            
             questionNumber = "1"
                
            }
            
            var ref: DatabaseReference!
            ref = Database.database().reference().child("Questions").child(userId!)
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let nowDate = formatter.string(from: date)
            
            guard let qntext = questionText.text else {
            return
            }
            
            //save user in firebase database
            
            let newUser = ["questionName": "Question \(questionNumber!)", "questionType": "Text", "caption": qntext,
                           "subject": subject.text,
                           "status": "Question Recieved", "questionDate": nowDate] as [String : Any]
            
            //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
            
            let key = ref.childByAutoId().key
            ref.child(key).setValue(newUser)
//update QuestionNumber
            defaults = UserDefaults.standard
            defaults.set(questionNumber, forKey: "questionNumber")
            
            //go to my questions
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideNavigationController")
            self.present(vc!, animated: true, completion: nil)
        
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionText.layer.borderWidth = 1.0
       questionText.layer.borderColor = UIColor.lightGray.cgColor
    
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
