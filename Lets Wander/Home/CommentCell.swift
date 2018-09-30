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
            textLabel.text = comment?.text
        }
    }
    
    let textLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 14)
       label.numberOfLines = 0
        label.backgroundColor = UIColor.lightGray
       return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.yellow
        addSubview(textLabel)
        _ = textLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 4 , bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
