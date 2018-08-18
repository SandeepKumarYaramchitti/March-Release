//
//  PhotoSelectorController.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 8/17/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit

class PhotoSelectorClass: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.yellow
        setUpNavigationButtons()
    }
    
    fileprivate func setUpNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc fileprivate func handleCancel() {
        return 
    }
    
    
    
}
