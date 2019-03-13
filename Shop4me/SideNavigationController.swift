//
//  SideNavigationController.swift
//  SideMenu
//
//  Created by Simon Peter Miyingo on 6/13/17.
//  Copyright © 2017 Simon Peter Miyingo. All rights reserved.
//

import UIKit

class SideNavigationController: ENSideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.navigationBar.barStyle = UIBarStyle.black
        //self.navigationBar.backgroundColor = UIColor.red
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let menu = storyboard?.instantiateViewController(withIdentifier: "menuTableViewController") as! menuTableViewController
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: menu, menuPosition: ENSideMenuPosition.left)
 sideMenu?.menuWidth = 300
        sideMenu?.bouncingEnabled = false

        view.bringSubview(toFront: navigationBar)
        

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
