//
//  ChooseGalleryViewController.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/26/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Photos

class ChooseGalleryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var captionLabel: UITextField!
    @IBOutlet weak var subjectLabel: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var chooseButton: UIButton!
    let imagePicker = UIImagePickerController()
    var imageData: Data?
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if subjectLabel.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter a", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
            
        else {
            
            //Get stored user details
            var defaults = UserDefaults.standard
            let userId = defaults.string(forKey: "userId")
            let email = defaults.string(forKey: "email")
            var questionNumber = defaults.string(forKey: "questionNumber")
            if questionNumber != nil {
                var   SquestionNumber = Int(questionNumber!)! + 1
                questionNumber = String(SquestionNumber)
                
            }else{
                questionNumber = "1"
            }
            
            //upload image
            
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            
            let reff = storageRef.child("Question Snaps").child(email!).child("Questions").child("Question \(questionNumber!)")
       let metadata = StorageMetadata()
           metadata.contentType = "image/jpeg"
            
            reff.putData(imageData!, metadata: metadata) { metadata, error in
       
                if let error = error{
                    print(error.localizedDescription)
                } else {
                    //successfully completed
                    
                    var ref: DatabaseReference!
                    ref = Database.database().reference().child("Questions").child(userId!)
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    let nowDate = formatter.string(from: date)
                    
                    guard let qntext = self.captionLabel.text else {
                        return
                    }
                    
                    //save user in firebase database
                    
                    let newUser = ["questionName": "Question \(questionNumber!)", "questionType": "Image", "caption": qntext,
                                   "subject": self.subjectLabel.text,
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        
        imagePicker.delegate = self
        submitButton.isHidden = true
        subjectLabel.isHidden = true
        captionLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        
        if let pickedImage = info [UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.contentMode = .scaleAspectFit
            self.imageView.image = pickedImage
             imageData = UIImageJPEGRepresentation(pickedImage, 0.5)
            submitButton.isHidden = false
            subjectLabel.isHidden = false
            captionLabel.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
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
