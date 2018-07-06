//
//  User.swift
//  RxDemo
//
//  Created by Aaron Musa on 02/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation

class User:NSObject, NSCoding {
    var id: String?
    var email: String?
    
    init(json: [String: Any]){
        id = json["id"] as? String
        email = json["email"] as? String
    }
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObject(forKey: "id") as? String
        self.email = decoder.decodeObject(forKey: "email") as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.email, forKey: "email")
    }
}
