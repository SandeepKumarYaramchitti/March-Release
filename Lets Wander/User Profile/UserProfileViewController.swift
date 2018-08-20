//
//  UserProfileViewController.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 3/25/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        navigationItem.title = "Lets Wander" //Set the Navigation Bar Heading
        
        //Get the current user from the Firebase
        navigationItem.title = Auth.auth().currentUser?.uid
        fetchUser()
        //Register Header
        registerCollectionCells()
        //SetUp Logout Button
        setUpLogOutButton()
        fetchPosts()
        
    }
    
    var posts = [PostModel]()
     func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observe(.value, with: { (snapshot) in
            // print(snapshot.value ?? "")
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key, value) in
             // print("Key \(key), Value: \(value)")
                guard let dictionary = value as? [String: Any] else {return}
                let post = PostModel(dictionary: dictionary)
                //print(post.imageURL)
                self.posts.append(post)
                
            })
            
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to post error", err)
        }
    }
    
    fileprivate func setUpLogOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal) ,style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    //Log Out features
    @objc fileprivate func handleLogOut(){
        print("Logging Out.")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Handle Logout feature
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            print("Perform Log Out")
            do {
                try Auth.auth().signOut()
                // What happenes ? We need to present some kind of Login Controller
                let logInController = LogInController()
                let navController = UINavigationController(rootViewController: logInController)
                self.present(navController, animated: true, completion: nil)
            }catch let signoutErr {
                print("Failed to Sign Out.",signoutErr)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //Register Header
    fileprivate func registerCollectionCells(){
        //Register the subclass to add a subclass cell within a collection View
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        //Register the second cell
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    //Set up the header for the User profile - Step 01
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        //header.backgroundColor  = UIColor.blue
        return header
    }
    
    //Set the header Size - Step02
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 270)
    }
    
    //Returns number of variables
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.item]
       // cell.backgroundColor = .blue
        return cell
    }
    
    //Size for Item at
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    //Minimum Horizental spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //Minimum Verticle Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    
    
    
    
    
    //Fetch the current user from Firebase and display the same on the userprofile heading
    var user: User?
    fileprivate func fetchUser(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "")
            guard let dictionary = snapshot.value as? [String:Any] else {return}
//            let profileImageUrl = userInfoDictionary["ProfileImageURL"] value as? String
//            let userName = userInfoDictionary["username"] as? String
            
            self.user = User(dictionary: dictionary)
            print("UserName",self.user?.username)
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch user",err)
        }
        
    }
}

struct User {
    let username: String
    let profileImageUrl: String
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["ProfileImageURL"] as? String ?? ""
    }
    
}

