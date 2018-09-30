//
//  HomeViewController.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 8/26/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    func didTapComment(post: PostModel) {
        print("Message coming from home controller")
        print("Post the caption:", post.capTion )
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        navigationController?.pushViewController(commentController, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Automatic Refresh of the page
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateNotificationName, object: nil)
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeViewCell.self, forCellWithReuseIdentifier: "homeID")
        
        //Set Up refresh Controller
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshController), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        setUpNavigationItems()
        fetchAllPosts()
    }
    
    @objc fileprivate func handleUpdateFeed() {
        handleRefreshController()
    }
    
    @objc fileprivate func handleRefreshController() {
        print("Handling Refresh..")
        posts.removeAll()
        fetchAllPosts()
        
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "")
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            userDictionary.forEach({ (key, value) in
                Database.fetchUserWithID(uid: key, completion: { (user) in
                    self.fetchPostswithUser(user: user)
                })
            })
        }) { (err) in
            print("Could not fetch followers of current ID:", err )
        }
    }

    func setUpNavigationItems() {
        navigationItem.title = "Let's Wander"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Camera").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc fileprivate func handleCamera() {
        print("Handling Camera")
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    //Fetch posts and we will use fetch with regular option
    var posts = [PostModel]()
    func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.fetchUserWithID(uid: uid) { (user) in
            self.fetchPostswithUser(user: user)
        }
        

    }
    
    fileprivate func fetchPostswithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observe(.value, with: { (snapshot) in
            self.collectionView?.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else {return}
                var post = PostModel(user: user, dictionary: dictionary)
                post.id = key
                self.posts.append(post)
            })
            
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
        }) { (err) in
            print("error and could not fetch user details", err)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat =  40 + 4 + 4
        height = height + view.frame.width
        height = height + 50 //For other components at the bottom
        height = height + 50 // For caption Label
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeID", for: indexPath) as! HomeViewCell
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    
}
