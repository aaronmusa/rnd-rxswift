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
    func signIn(email: String, password: String) -> Observable<Any>
    func signOut() -> Observable<Any>
    func signUp(email: String, password: String) -> Observable<Any> 
    func getCurrentSession() -> Observable<Device?> 
    func saveSession(json: [String:Any]) 
    func removeCurrentSession() 
}

class Repository: RepositoryProtocol {
    
    
    static var shared: Repository = Repository()
    
    private var firebaseAuth: Auth = Auth.auth()
    private let cacheManager = CacheManager.shared
    
    private var currentSession: Device?
    private let bag = DisposeBag()
    
    func signIn(email: String, password: String) -> Observable<Any>{
        return Observable.create({ (observer) in
            self.firebaseAuth.signIn(withEmail: email, password: password, completion: { (user, error) in
                if user != nil {
                    user?.getIDToken(completion: { (token, tokenFail) in
                        if tokenFail != nil {
                            observer.onError(tokenFail!)
                        }
                        
                        let userData: [String: Any] = ["id": user!.uid,
                                                       "email": user!.email ?? ""]
                        let sessionData: [String: Any] = ["accessToken": token ?? "",
                                                          "user": userData]
                        
                        self.saveSession(json: sessionData)
                        
                        let currentuser = User(json: userData)
                        observer.onNext(currentuser)
                        observer.onCompleted()
                    })
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
    
    func signOut() -> Observable<Any>{
        return Observable.create({ observer in
            do {
                try self.firebaseAuth.signOut()
                self.removeCurrentSession()
                observer.onNext(())
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            
            return Disposables.create()
        })
    }
    
    func signUp(email: String, password: String) -> Observable<Any> {
        return Observable.create({ observer in
            self.firebaseAuth.createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    observer.onError(error!)
                }
                if user != nil {
                    self.signIn(email: user?.email ?? "", password: password).subscribe(onNext: { (_ ) in
                        observer.onNext(())
                    }, onError: { (error) in
                        observer.onError(error)
                    }).disposed(by: self.bag)
                }
            })
            return Disposables.create()
        })
    }
    
    //MARK: - Session
    func saveSession(json: [String:Any]) {
        currentSession = Device(json: json)
        if currentSession != nil {
            cacheManager.saveSession(currentSession!)
        }
    }
    
    func getCurrentSession() -> Observable<Device?> {
        return Observable.create({ observer in
            self.cacheManager.getCurrentSession().subscribe(onNext: { (device) in
                observer.onNext(device)
//                observer.onCompleted()
            }).disposed(by: self.bag)
            return Disposables.create()
        })
    }
    
    func removeCurrentSession() {
        cacheManager.removeCurrentSession()
    }
}
