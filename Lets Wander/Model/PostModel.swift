//
//  PostModel.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 8/19/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import Foundation

struct PostModel {
    let imageURL: String
    init(dictionary: [String: Any]) {
        self.imageURL = dictionary["ImageUrl"] as? String ?? ""
    }
}
