//
//  LoginViewModel.swift
//  RxDemo
//
//  Created by Aaron Musa on 01/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

struct LoginViewModel {
    
    var email = Variable<String>("")
    var password = Variable<String>("")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest( self.email.asObservable(), self.password.asObservable())
        { (email, password) in
            return email.count >= 3
                && password.count >= 3
        }
    }
    
    func signIn(success: @escaping () -> Void,
                failed: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email.value, password: password.value) { (user, error) in
            if let _ = user {
                success()
            }
            else{
                print(error?.localizedDescription ?? "")
                failed()
            }
        }
    }
    
    func signOut() -> Observable<Any> {
        return Observable.create({ (observer) -> Disposable in
            do {
                try Auth.auth().signOut()
                observer.onCompleted()
            } catch let error as NSError {
                print(error.localizedDescription)
                observer.onError(error)
            }
        })
        return Disposables.create()
    }
}
