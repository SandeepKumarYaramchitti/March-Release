//
//  CommentController.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 9/28/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Firebase

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var post: PostModel?
    let cellID = "cellid"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellID)
        fetchPosts()
        
    }
    
    var comments = [Comment]()
    fileprivate func fetchPosts() {
        guard let postID = self.post?.id else {return}
        Database.database().reference().child("Comments").child(postID).observe(.childAdded, with: { (snapshot) in
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            
            guard let uid = dictionary["uid"] as? String else {return}
            Database.fetchUserWithID(uid: uid, completion: { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView?.reloadData()
            })
            
        }) { (err) in
            print("Error in fetching the data..", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CommentCell
        cell.comment = self.comments[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize =  dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView: UIView =  {
        let containerView = UIView()
//        containerView.backgroundColor = UIColor.white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let sendButton =  UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(UIColor.blue, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(handlesendButton), for: .touchUpInside)
        containerView.addSubview(sendButton)
        _ = sendButton.anchor(containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 0)
        
  
        containerView.addSubview(self.containerTextView)
        _ = self.containerTextView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)
        containerView.addSubview(lineSeparatorView)
        _ = lineSeparatorView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        return containerView
    }()
    
    let containerTextView: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comments"
        return textField
    }()
    
    @objc fileprivate func handlesendButton() {
        print("Handling Send button....")
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        print("Post ID:", self.post?.id ?? "")
        let postID = self.post?.id ?? ""
        
        let values = ["text":containerTextView.text ?? "", "cretionDate": Date().timeIntervalSince1970, "uid": uid ] as [String: Any]
        Database.database().reference().child("Comments").child(postID).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to update the DB", err)
                return
            }
            
            print("Successfully inserted the commnets")
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
        
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
