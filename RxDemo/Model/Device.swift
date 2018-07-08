//
//  Device.swift
//  RxDemo
//
//  Created by Aaron Musa on 04/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation

class Device: NSObject, NSCoding {
    var accessToken: String?
    var user: User?
    
    init(json: [String: Any]) {
        accessToken = json["accessToken"] as? String
        user = User(json: json["user"] as! [String: Any])
    }
    
    required init(coder decoder: NSCoder) {
        self.accessToken = decoder.decodeObject(forKey: "accessToken") as? String
        self.user = decoder.decodeObject(forKey: "user") as? User
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.accessToken, forKey: "accessToken")
        coder.encode(self.user, forKey: "user")
    }
}
