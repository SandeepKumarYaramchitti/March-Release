//
//  User.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 9/6/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["ProfileImageURL"] as? String ?? ""
    }
    
}
