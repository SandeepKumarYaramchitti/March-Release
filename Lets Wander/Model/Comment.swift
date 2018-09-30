//
//  Comment.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 9/30/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import Foundation

struct Comment {
    let text: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
}
