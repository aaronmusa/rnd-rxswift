//
//  Repository.swift
//  RxDemo
//
//  Created by Aaron Musa on 04/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift

protocol RepositoryProtocol {
    func signIn(email: String, password: String) -> Observable<User>
}

class Repository: RepositoryProtocol {
    
    static var shared: Repository = Repository()
    
    private var firebaseAuth: Auth = Auth.auth()
    private let cacheManager = CacheManager.shared
    
    private var currentSession: Device?
    
    func signIn(email: String, password: String) -> Observable<User>{
        return Observable.create({ (observer) in
            self.firebaseAuth.signIn(withEmail: email, password: password, completion: { (user, error) in
                if user != nil {
                    let userData: [String: Any] = ["id": user!.uid, "email": user!.email ?? ""]
                    let sessionData: [String: Any] = ["accessToken": "testidTOken",
                                               "user": userData
                    ]
                    
                    self.saveSession(json: sessionData)
                    
                    let currentuser = User(json: userData)
                    observer.onNext(currentuser)
                    observer.onCompleted()
                }
                else {
                    if error != nil {
                        observer.onError(error!)
                    }
                }
            })
            return Disposables.create()
        })
    }
    
    //MARK: - Session
    private func saveSession(json: [String:Any]) {
        currentSession = Device(json: json)
        if currentSession != nil {
            cacheManager.saveSession(currentSession!)
        }
    }
    
    func getCurrentSession() -> Device? {
        return cacheManager.getCurrentSession()
    }
}
