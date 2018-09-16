//
//  SearchViewCell.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 9/8/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit

class SearchViewCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            userNameLebel.text = user?.username
            guard let profileImageUrl = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
       let iv = CustomImageView()
       iv.backgroundColor = UIColor.red
       iv.contentMode = .scaleAspectFit
       iv.clipsToBounds = true
       iv.layer.cornerRadius = 50 / 2
       return iv
    }()
    
    let userNameLebel: UILabel = {
       let label = UILabel()
       label.text = "UserName"
       label.font = UIFont.boldSystemFont(ofSize: 14)
       return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(userNameLebel)
        _ = profileImageView.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        _ = userNameLebel.anchor(topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        // Line Separator creation
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        _ = separatorView.anchor(nil, left: userNameLebel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
