//
//  CustomImageView.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 8/25/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()
class CustomImageView: UIImageView {
    //Function to load the images
    var lastURLusedToLoadImage: String?
    func loadImage(urlString: String) {
        lastURLusedToLoadImage = urlString
        self.image = nil
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else {return}
    
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Error in updating the cell", err)
                return
            }
            
            if url.absoluteString != self.lastURLusedToLoadImage {
                return
            }
            
            guard let imageData = data else {return}
            
            let photoImage = UIImage(data: imageData)
            //Image Cache
            imageCache[url.absoluteString] = photoImage
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
}
