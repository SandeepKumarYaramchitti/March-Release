//
//  MainTabBarController.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 3/25/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //Selection of View Controller - This depends on the UITab bar contoroller Delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        print(index ?? "")
        
        if index == 1 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController =  PhotoSelectorClass(collectionViewLayout: layout)
            let photoNavContorller = UINavigationController(rootViewController: photoSelectorController)
            present(photoNavContorller, animated: true, completion: nil)
        }
        
        return true
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.delegate = self
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
        //Home Profile Controller
        let homeProfileViewController = temlateNavContorller(unselectedImage: #imageLiteral(resourceName: "icons8-home-50 (1)"), selectedImage: #imageLiteral(resourceName: "icons8-home-filled-50 (1)"), rootViewController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let photoSelectionContorller = temlateNavContorller(unselectedImage: #imageLiteral(resourceName: "plus-photo-button"), selectedImage: #imageLiteral(resourceName: "plus-photo-button"), rootViewController: UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        let layout = UICollectionViewFlowLayout()
        let userProfileViewController = UserProfileViewController(collectionViewLayout: layout)
        //Add a Navigation Controller - Step02
        let userProfileNavController = UINavigationController(rootViewController: userProfileViewController)
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        tabBar.tintColor = UIColor.blue
        viewControllers = [homeProfileViewController, photoSelectionContorller, userProfileNavController]
        
        //Modify Tab bar Insets - Not Documented on IOS Documentation
        
        guard let items = tabBar.items else {return}
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func temlateNavContorller(unselectedImage: UIImage?, selectedImage: UIImage,
                                          rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let ProfileViewController = rootViewController
        let NavViewContorller = UINavigationController(rootViewController: ProfileViewController)
        NavViewContorller.tabBarItem.image = unselectedImage
        NavViewContorller.tabBarItem.selectedImage = selectedImage
        return NavViewContorller
    }
}
