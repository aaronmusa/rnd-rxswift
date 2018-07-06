//
//  LoginViewModel.swift
//  RxDemo
//
//  Created by Aaron Musa on 01/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ViewState {
    case loading
    case success
    case error
}

struct LoginViewModel {
    
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var bag = DisposeBag()
    
//    var isLoading: Driver<Bool>
//    var failed: Driver<Bool>
//    var success: Driver<User?>
    
    var repository: Repository!
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest( self.email.asObservable(), self.password.asObservable())
        { (email, password) in
            return email.count >= 5
                && password.count >= 5
        }
    }
    
//    var userCredentials: Observable<(email: String, password: String)> {
//        return Observable.combineLatest(email, password) { (email, password) -> (String, String) in
//            (email, password)
//        }
//    }
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    //    func signIn() -> Observable<Any>{
    //        return Observable.create({ (observer) -> Disposable in
    //            Auth.auth().signIn(withEmail: self.email.value, password: self.password.value) { (user, error) in
    //                if let _ = user {
    //                    observer.onNext(true)
    //                }
    //                else{
    //                    print(error?.localizedDescription ?? "")
    //                    observer.onError(error!)
    //                }
    //
    //                observer.onCompleted()
    //            }
    //            return Disposables.create()
    //        })
    //    }
    
    func signIn() -> Observable<User> {
        return Observable.create({ (observer) -> Disposable in
            self.repository.signIn(email: self.email.value, password: self.password.value).subscribe(onNext: { user in
                
                observer.onNext(user)
            },
            onError: { error in
                print("error")
                observer.onError(error)
            },
            onCompleted: {
                print("completed")
            }).disposed(by: self.bag)
            
            return Disposables.create()
        })
    }
    
//    init(repository: Repository, driver: Driver<Void>) {
//        let loginDriver = driver.startWith(()).flatMapLatest{ _ -> Driver<ViewState> in
//
//            return repository.signIn(email: "adadasdas", password: "asadsdas")
//                .map { .success($0) }
//                .asDriver(onErrorJustReturn: .error)
//                .startWith(.loading)
//        }
//
//        self.isLoading = loginDriver.map{ state in
//            switch state {
//            case .loading:
//                print("loading")
//                return true
//            default:
//                return false
//            }
//        }
//
//        self.failed = loginDriver.map { state in
//            switch state {
//            case .error:
//                print("error")
//                return true
//            default:
//                return false
//            }
//        }
//
//        self.success = loginDriver.map{ state -> User? in
//            switch state {
//            case .success(let user):
//                print("success")
//                return user
//            default:
//                return nil
//            }
//        }
//
//    }
    

    
//    func signOut(success: @escaping: () -> Void) {
//        return Observable.create({ (observer) -> Disposable in
//            do {
//                try Auth.auth().signOut()
//                observer.onCompleted()
//            } catch let error as NSError {
//                print(error.localizedDescription)
//                observer.onError(error)
//            }
//        })
//    }
}
