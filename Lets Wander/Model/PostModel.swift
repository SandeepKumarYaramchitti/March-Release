//
//  PostModel.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 8/19/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import Foundation

struct PostModel {
    let user: User
    let imageURL: String
    let capTion: String
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageURL = dictionary["ImageUrl"] as? String ?? ""
        self.capTion = dictionary["Caption"] as? String ?? ""
    }
}
