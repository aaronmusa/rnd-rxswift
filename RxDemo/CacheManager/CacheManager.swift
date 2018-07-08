//
//  CacheManager.swift
//  RxDemo
//
//  Created by Aaron Musa on 07/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CacheManager: NSObject {
    let defaults = UserDefaults.standard
    
    private let currentSessionKey: String = "currentSession"
    
    static let shared = CacheManager()
    
    let bag = DisposeBag()
    
    //MARK: Current Session
    private var currentSession = BehaviorRelay<Device?>(value: nil)
    
    func getCurrentSession() -> Observable<Device?> {
        return Observable.create({ observer in
            self.currentSession.subscribe(onNext: { (device) in
                if let data = self.defaults.object(forKey: self.currentSessionKey) as? NSData{
                    observer.onNext(NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? Device)
                }
                else{
                    observer.onNext(device)
                }
//                observer.onCompleted()
            }).disposed(by: self.bag)
            return Disposables.create()
        })
    }
    
    func saveSession(_ session: Device) {
        self.defaults.set(NSKeyedArchiver.archivedData(withRootObject: session), forKey: currentSessionKey)
        self.defaults.synchronize()
        currentSession.accept(session)
    }
        
    func removeCurrentSession() {
        self.defaults.removeObject(forKey: self.currentSessionKey)
        currentSession.accept(nil)
    }

}
