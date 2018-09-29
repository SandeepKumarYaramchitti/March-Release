//
//  PreviewPhotoContainerView.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 9/18/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
       let iv = UIImageView()
       return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Download"), for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleSaveButton() {
        print("Handling save photos...")
        guard let previewImage = previewImageView.image else {return}
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, err) in
            if let err = err {
                print("Failed to save image", err)
                return
            }
            print("Successfully stored the photo to local")
            DispatchQueue.main.async {
                //Animation on the page
                let saveLabel = UILabel()
                saveLabel.text = "Saved Successfully"
                saveLabel.textColor = UIColor.white
                saveLabel.numberOfLines = 0
                saveLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                saveLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                saveLabel.center = self.center
                saveLabel.textAlignment = .center
                self.addSubview(saveLabel)
                saveLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                //Animate the label
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                     saveLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed) in
                    //Completed Code
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                         saveLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        saveLabel.alpha = 0
                    }, completion: { (_) in
                        saveLabel.removeFromSuperview()
                    })
                })
                
            }

        }
    }
    
    @objc fileprivate func handleCancelButton() {
        self.removeFromSuperview()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(previewImageView)
        _ = previewImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        addSubview(cancelButton)
        _ = cancelButton.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        cancelButton.layer.cornerRadius = 70 / 2
        cancelButton.clipsToBounds = true
        
        addSubview(saveButton)
        _ = saveButton.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 24, rightConstant: 0, widthConstant: 50, heightConstant: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
