//
//  MainTabBarController.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 3/25/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            //Show In case user is not logged in
            
            DispatchQueue.main.async {
                let loginController = LogInController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        setUpViewControllers()
    }
    func setUpViewControllers() {
        
        let layout = UICollectionViewFlowLayout()
        let userProfileViewController = UserProfileViewController(collectionViewLayout: layout)
        //Add a Navigation Controller - Step02
        let navController = UINavigationController(rootViewController: userProfileViewController)
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        tabBar.tintColor = UIColor.blue
        viewControllers = [navController, UIViewController()]
        
    }
}
