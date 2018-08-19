//
//  SharePhotoController.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 8/18/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    var selectedImage: UIImage? {
        didSet{
            self.shareImageView.image = selectedImage
        }
    }
    override func viewDidLoad() {
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        setUpImageandTextViews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc fileprivate func handleShare(){
        print("Shared Shared and Shared!!!!")
        guard let caption = addTextView.text, caption.characters.count > 0 else {return}
        let fileName = NSUUID().uuidString
        guard let image = selectedImage else {return}
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else {
            return
        }
        Storage.storage().reference().child("posts").child(fileName).putData(uploadData, metadata: nil) { (metaData, err) in
            if let err = err {
                print("COuild not update to Firebase", err)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            guard let imageURL =  metaData?.downloadURL()?.absoluteString else {return}
            print("Succcesfully uploaded Data", imageURL)
            self.saveImagetoFirebaseDB(imageURL: imageURL)
        }
    }
    
    fileprivate func saveImagetoFirebaseDB(imageURL: String) {
        guard let postImage = selectedImage else {return}
        guard let caption = addTextView.text else {return}
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let userPostRef = Database.database().reference().child("posts").child(currentUID)
        let ref = userPostRef.childByAutoId()
        let values = ["ImageUrl": imageURL, "Caption": caption, "ImageWidth":postImage.size.width, "ImageHeight": postImage.size.height, "CreationDate": Date().timeIntervalSince1970] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Error is updating firebase DB", err)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            print("Successfully Posted to DB")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    let shareImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFill
       imageView.clipsToBounds = true
       return imageView
    }()
    
    let addTextView: UITextView = {
       let textView = UITextView()
       textView.font = UIFont.systemFont(ofSize: 14)
       return textView
    }()
    
    fileprivate func setUpImageandTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        view.addSubview(containerView)
        _ = containerView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        
        containerView.addSubview(shareImageView)
        _ = shareImageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 84, heightConstant: 0)
        
        
        containerView.addSubview(addTextView)
        _ = addTextView.anchor(containerView.topAnchor, left: shareImageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
















