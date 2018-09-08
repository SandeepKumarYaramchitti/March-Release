//
//  FireBaseUtils.swift
//  Lets Wander
//
//  Created by Sandeep Kumar  Yaramchitti on 9/8/18.
//  Copyright © 2018 Sandeep Kumar  Yaramchitti. All rights reserved.
//

import Foundation
import Firebase


extension Database {
    static func fetchUserWithID(uid: String, completion: @escaping (User) -> ()){
        print("Fetching user ID with UID:", uid )
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            let user = User(uid: uid, dictionary: userDictionary)
            print(user.username)
            //  self.fetchPostswithUser(user: user)
            completion(user)
            
        }) { (err) in
            print("Failed to post error", err)
        }
    }
}
