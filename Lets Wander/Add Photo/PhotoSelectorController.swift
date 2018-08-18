//
//  PhotoSelectorController.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 8/17/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorClass: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.yellow
        setUpNavigationButtons()
        
        //Register Cell - Step01
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: "cellID")
        
        //Render the Header of the page
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        
        //Fetch Available Photos on simulators
        fetchPhotos()
    }
    
    //Fetch photos from the device
    var images = [UIImage]()
    fileprivate func fetchPhotos(){
        print("Fetching Photos")
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let sortDescriptor = NSSortDescriptor(key: "CreationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        let allphotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        allphotos.enumerateObjects { (asset, count, stop) in
            print(asset)
            
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: 350, height: 350)
        let option = PHImageRequestOptions()
        option.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option, resultHandler: { (image, info) in
                
                if let image = image {
                  self.images.append(image)
                }
                
                if count == allphotos.count - 1 {
                    self.collectionView?.reloadData()
                }
            })
        }
    }
    
    //Header ID
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath)
        header.backgroundColor = UIColor.blue
        return header
    }
    
    //Referece Size for Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    //Provide a line gap between Header and Main images
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    //Step02 - Number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    //Step03 - Cell for item at
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! PhotoSelectorCell
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    
    //Step04 Size for item at - This comes from UICollectionViewDelegate Flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ( view.frame.width - 3 ) / 4
        return CGSize(width: width, height: width)
    }
    
    //Minimum Line Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //Minimum Inter difference
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //Hide the Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Set Up the navigation bar items
    fileprivate func setUpNavigationButtons() {
        navigationController?.navigationBar.tintColor = UIColor.blue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    //Cancel the photo selection
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //Handle Next button on photo selector
    @objc fileprivate func handleNext(){
        print("Next Next Next")
    }
    
    
    
}
