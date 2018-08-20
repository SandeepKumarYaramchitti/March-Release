//
//  Post.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 8/19/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import UIKit

struct Posts {
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["ImageUrl"] as? String ?? ""
    }
}
