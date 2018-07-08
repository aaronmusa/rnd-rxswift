//
//  SignUpViewModel.swift
//  RxDemo
//
//  Created by Aaron Musa on 07/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    
    private var repository: RepositoryProtocol!
    let bag = DisposeBag()
    
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(self.email.asObservable(), self.password.asObservable()){ (email, password) in
            
            return email.count <= 5 && email.isValidEmail() && password.count <= 5
        }
    }
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func signUp() -> Observable<Any> {
        return Observable.create({ observer in
            self.repository.signUp(email: self.email.value, password: self.password.value).subscribe(onNext: { (_ ) in
                observer.onNext(())
            }, onError: { (error) in
                observer.onError(error)
            }).disposed(by: self.bag)

            return Disposables.create()
        })
    }
}
