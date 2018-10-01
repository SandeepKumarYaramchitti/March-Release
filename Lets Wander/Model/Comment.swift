//
//  Comment.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 9/30/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import Foundation

struct Comment {
    
    let user: User
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
}
