//
//  CategoryViewController.swift
//  Shop4me
//
//  Created by Simon Peter Miyingo on 7/6/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ENMBadgedBarButtonItem

class CategoryViewController: ButtonBarPagerTabStripViewController {
     var ctId:Int?
    var bURL:String?
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    let appDele = UIApplication.shared.delegate as! AppDelegate

    func cartButtonTapped(){
        
        let  pdVc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        pdVc.selectedIndex = 2
        self.navigationController?.pushViewController(pdVc, animated: true)
        
        
    }
  
    override func viewDidLoad() {
        let mcolor = hexStringToUIColor(hex: "#43B02A")
   bURL = appDele.BaseURL
       // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = mcolor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 6.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .gray
        settings.style.buttonBarItemsShouldFillAvailiableWidth = false
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = mcolor//self?.purpleInspireColor
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            } else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            
        }
        
        let catItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Cart-Selected"), landscapeImagePhone: UIImage(named: "Cart-Selected"), style: .plain, target: self, action: #selector(CategoryViewController.cartButtonTapped))
        catItem.tintColor = UIColor.white
        navigationItem.setRightBarButton(catItem, animated: false)
        
        /*
        let image = UIImage(named: "Cart-Selected")
        let buttonFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: image!.size.width, height: image!.size.height)
        let barButton = BadgedBarButtonItem(
            startingBadgeValue: 2,
            frame: buttonFrame,
            image: image
        )
       let leftBarButton = barButton
        leftBarButton.addTarget(self, action: #selector(CategoryViewController.cartButtonTapped))
        barButton.tintColor = UIColor.white
        leftBarButton.tintColor = UIColor.white
        //navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.setRightBarButton(leftBarButton, animated: false)*/
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
       // let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryViewController")
        
        
    
       
     
        var arrayToReturn = [UIViewController]()
     
        if ctId! == 0 { //Dairy n Milk
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName = "Milk"
            c1.catId = "104"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName = "Eggs"
             c2.catId = "105"
            let c3 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c3.topName = "Yogurt"
             c3.catId = "106"
            let c4 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c4.topName = "Butter"
             c4.catId = "107"
            let c5 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c5.topName = "Ice Cream"
             c5.catId = "108"
            let c6 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c6.topName = "Cheese"
             c6.catId = "109"
            let c7 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c7.topName = "Powdered Milk"
            
 c7.catId = "110"
            arrayToReturn = [c1,c2,c3,c4,c5,c6,c7]

            
        }
     else if ctId! == 1{ //Fruits
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName = "Fresh Fruits"
            c1.catId = "100"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName="Fresh Vegetables"
            c2.catId = "101"
            let c3 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c3.topName="Packaged Fruits & Veggies"
            c3.catId = "102"
            let c4 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c4.topName="Fresh Herbs"
            c4.catId = "103"
            arrayToReturn = [c1,c2,c3,c4]
            
        }
            
        else if ctId! == 2 { //Bakery
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName="Bread"
            c1.catId = "110"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName="Doghnuts"
            c2.catId = "111"
            let c3 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c3.topName="Cookies"
            c3.catId = "112"
            let c4 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c4.topName="Cakes"
            c4.catId = "113"
            arrayToReturn = [c1,c2,c3,c4]
            
        }
        
        else if ctId! == 3 { //Soft Drinks
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName="Soda"
            c1.catId = "114"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName="Water"
            c2.catId = "115"
            let c3 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c3.topName="Juices"
            c3.catId = "116"
            let c4 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c4.topName="Energy Drinks"
            c4.catId = "117"
            arrayToReturn = [c1,c2,c3,c4]
            
        }
        
       else if ctId! == 4 { //Fruits
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName="Rice"
            c1.catId = "118"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName="Pasta"
            c2.catId = "119"
            arrayToReturn = [c1,c2]
        }
        
        else if ctId! == 5 { //Fruits
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName="Cereal"
            c1.catId = "120"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName="Coffee"
            c2.catId = "121"
            let c3 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c3.topName="Tea"
            c3.catId = "122"
            arrayToReturn = [c1,c2,c3]
        }
        
        else if ctId! == 6 { //Fruits
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName="Crisps"
            c1.catId = "123"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName="Biscuits"
            c2.catId = "124"
            let c3 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c3.topName="Chocolates"
            c3.catId = "125"
            let c4 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c4.topName="Candy"
            c4.catId = "126"
            let c5 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c5.topName="Nuts & Seeds"
            c5.catId = "127"
            arrayToReturn = [c1,c2,c3,c4,c5]
        }
        
        else if ctId! == 7 { //Fruits
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName="Chicken"
            c1.catId = "128"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName="Beef"
            c2.catId = "129"
            let c3 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c3.topName="Seafood"
            c3.catId = "130"
            let c4 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c4.topName="Pork"
            c4.catId = "131"
            arrayToReturn = [c1,c2,c3,c4]
        }
        else if ctId! == 8 { //Fruits
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName="Skin Care"
            c1.catId = "132"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName="Deodrants"
            c2.catId = "133"
            let c3 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c3.topName="Soap"
            c3.catId = "134"
            let c4 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c4.topName="Feminine Care"
            c4.catId = "135"
            let c5 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c5.topName="Hair Care"
            c5.catId = "136"
            arrayToReturn = [c1,c2,c3,c4,c5]
        }
        else if ctId! == 9 { //Fruits
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName="Diapers & Wipes"
            c1.catId = "137"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName="Baby Food & Formula"
            c2.catId = "138"
            let c3 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c3.topName="Baby Accessories"
            c3.catId = "139"
            let c4 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c4.topName="Bath & Body Care"
            c4.catId = "140"
            arrayToReturn = [c1,c2,c3,c4]
        }
        else if ctId! == 10 { //Fruits
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName="Beer"
            c1.catId = "141"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName="Wine"
            c2.catId = "142"
            let c3 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c3.topName="Liquer"
            c3.catId = "143"
            let c4 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c4.topName="Whiskey"
            c4.catId = "144"
            let c5 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c5.topName="Rum"
            c5.catId = "145"
            let c6 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c6.topName="Gin"
            c6.catId = "146"
            let c7 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c7.topName="Vodka"
            c7.catId = "147"
            arrayToReturn = [c1,c2,c3,c4,c5,c6,c7]
        }
        else if ctId! == 11 { //Fruits
            let c1 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c1.topName = "Cooking Oil"
            c1.catId = "149"
            let c2 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c2.topName="Spices & Seasonings"
            c2.catId = "150"
            let c3 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c3.topName="Spreads"
            c3.catId = "151"
            let c4 = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
            c4.topName = "Condiments"
            c4.catId = "152"
            arrayToReturn = [c1,c2,c3,c4]
        }
       return arrayToReturn
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
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#43B02A")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
