//
//  MockRepository.swift
//  RxDemo
//
//  Created by Aaron Musa on 07/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MockData {
    static let mockUserJson: [String: Any] = ["id": "TEST_ID1",
                                              "email": "aaron@gmail.com"]
    static let mockSessionJson: [String: Any] = ["accessToken": "TOKEN_ID1",
                                                 "user": mockUserJson]
}

class MockRepository: RepositoryProtocol {
    
    static var shared: MockRepository = MockRepository()
    
    var currentSession: Device?
    
    func signIn(email: String, password: String) -> Observable<Any> {
        return Observable.create({ observer in
            
            let mockUserJson: [String: Any] = ["id": "TEST_ID1",
                                                      "email": email]
            let mockSessionJson: [String: Any] = ["accessToken": "TOKEN_ID1",
                                                         "user": mockUserJson]
            
            let mockSession = Device(json: mockSessionJson)
            
            self.currentSession = mockSession
            
            if self.currentSession != nil {
                observer.onNext(())
                observer.onCompleted()
            }
            else{
                let error = NSError(domain: "mockDOmain", code: 400, userInfo: ["message": "Bad Request"])
                observer.onError(error)
            }
            return Disposables.create()
        })
    }
    
    func signOut() -> Observable<Any> {
        return Observable.create({ observer in
            self.currentSession = nil
            
//            self.currentSession = Device(json: MockData.mockSessionJson)
            
            if self.currentSession == nil {
                observer.onNext(())
                observer.onCompleted()
            }
            else{
                let error = NSError(domain: "Signout domain", code: 400, userInfo: ["message": "Session not deinit"])
                observer.onError(error)
            }
            return Disposables.create()
        })
    }
    
    func signUp(email: String, password: String) -> Observable<Any> {
        return Observable.create({ observer in
            
            return Disposables.create()
        })
    }
    
    func saveSession(json: [String : Any]) {
        currentSession = Device(json: json)
    }
    
    func getCurrentSession() -> Observable<Device?> {
        return Observable.create({ observer in
            
            return Disposables.create()
        })
    }
    
    func removeCurrentSession() {
        currentSession = nil
    }
    
    
}
