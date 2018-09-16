//
//  HomeViewCell.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 8/26/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit

class HomeViewCell: UICollectionViewCell {
    
    var post: PostModel? {
        didSet {
            print(post?.imageURL ?? "")
            guard let photoImageURL = post?.imageURL else {return}
            photoImageView.loadImage(urlString: photoImageURL)
            userNameLabel.text = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageUrl else {return}
            userProfileImageView.loadImage(urlString: profileImageUrl)
//            captionButton.text = post?.capTion
            setUpCaptionText()
        }
    }
    
    fileprivate func setUpCaptionText() {
        
        guard let post = post else {return}
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: " \(post.capTion)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11)]))
        attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
        
        //Actual Time Display
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        
        attributedText.append(NSMutableAttributedString(string: timeAgoDisplay, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.red]))
        captionButton.attributedText = attributedText
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 50 / 2
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
       let button = UIButton(type: .system)
       button.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        return button
    }()
    
    let heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        return button
    }()
    
    
    let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        return button
    }()
    
    let captionButton: UILabel = {
       let label = UILabel()
       label.text = "SOMETHING SOMETHING SOMETHING"
       
       label.numberOfLines = 0
       return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // backgroundColor = UIColor.darkGray
        addSubview(photoImageView)
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(optionsButton)
        
        _ = photoImageView.anchor(userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        _ = userProfileImageView.anchor(topAnchor, left: leftAnchor, bottom: photoImageView.topAnchor, right: nil, topConstant: 4, leftConstant: 4, bottomConstant: 4, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        _ = userNameLabel.anchor(topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: optionsButton.leftAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = optionsButton.anchor(topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
        setUpActionButtons()
        addSubview(captionButton)
        _ = captionButton.anchor(likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func setUpActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, heartButton, refreshButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        _ = stackView.anchor(photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
