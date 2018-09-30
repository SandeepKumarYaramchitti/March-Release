//
//  PostModel.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 8/19/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import Foundation

struct PostModel {
    var id: String?
    let user: User
    let imageURL: String
    let capTion: String
    let creationDate: Date
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageURL = dictionary["ImageUrl"] as? String ?? ""
        self.capTion = dictionary["Caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
