//
//  UserProfilePhotoCell.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 8/19/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    var post: PostModel? {
        didSet{
            print(post?.imageURL ?? "")
            guard let imageUrl = post?.imageURL else {return}
            guard let url = URL(string: imageUrl) else {return}
            
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    print("Error in updating the cell", err)
                    return
                }
                
                guard let imageData = data else {return}
                let photoImage = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.photoImageView.image = photoImage
                }
                
            }.resume()
            
        }
    }
    
    let photoImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.backgroundColor = UIColor.red
       imageView.contentMode = .scaleAspectFill
       imageView.clipsToBounds = true
       return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        _ = photoImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


