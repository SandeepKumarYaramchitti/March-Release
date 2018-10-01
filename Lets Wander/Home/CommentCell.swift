//
//  CommentCell.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 9/30/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet{
            guard let comment = comment else {return}
//            guard let profileImageURL = comment.user.profileImageUrl else {return}
//
//            guard let userName = comment.user.username else {return}
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]))
            textLabel.attributedText = attributedText
            profileImageView.loadImage(urlString: comment.user.profileImageUrl)
        }
    }
    
    let textLabel: UITextView = {
       let label = UITextView()
       label.font = UIFont.systemFont(ofSize: 14)
       label.isScrollEnabled = false
       return label
    }()
    
    let profileImageView: CustomImageView = {
       let iv = CustomImageView()
       iv.clipsToBounds = true
       iv.contentMode = .scaleAspectFill
       return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        _ = profileImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        addSubview(textLabel)
        _ = textLabel.anchor(topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 4 , bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
