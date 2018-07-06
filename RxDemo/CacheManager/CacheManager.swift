//
//  CacheManager.swift
//  RxDemo
//
//  Created by Aaron Musa on 07/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import UIKit

class CacheManager: NSObject {
    let defaults = UserDefaults.standard
    
    private let currentSessionKey: String = "currentSession"
    
    static let shared = CacheManager()
    
    //MARK: Current Session
    private var currentSession: Device?{
        get{
            if let data = self.defaults.object(forKey: currentSessionKey) as? NSData{
                return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? Device
            }
            return nil
        }
        set(newValue){
            self.defaults.set(NSKeyedArchiver.archivedData(withRootObject: newValue!), forKey: currentSessionKey)
            self.defaults.synchronize()
            
        }
    }
    
    func getCurrentSession() -> Device? {
        return currentSession
    }
    
    func saveSession(_ session: Device) {
        currentSession = session
    }
        
    func removeCurrentSession() {
        self.defaults.removeObject(forKey: self.currentSessionKey)
    }

}
