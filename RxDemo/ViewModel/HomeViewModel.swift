//
//  HomeViewModel.swift
//  RxDemo
//
//  Created by Aaron Musa on 07/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    private let cacheManager = CacheManager.shared
    var repository: RepositoryProtocol!
    let bag = DisposeBag()
    
    var hasUserLoggedIn: Observable<Bool> {
        return Observable.create({ observer in
            if self.repository?.getCurrentSession() != nil {
                observer.onNext(true)
            }
            else{
                observer.onNext(false)
            }
            
            observer.onCompleted()
            
            return Disposables.create()
        })
    }
    
    init(_ repository: RepositoryProtocol) {
        self.repository = repository
    
    }
    
    func observeCurrentSession() -> Observable<Device?> {
        return Observable.create({ observer in
            self.repository.getCurrentSession().subscribe(onNext: { (device) in
                observer.onNext(device)
//                observer.onCompleted()
            }).disposed(by: self.bag)
            return Disposables.create()
        })
    }

    
    func signOut(){
        repository.signOut().subscribe(onNext: { (_ ) in
        }, onError: { (error) in
            print(error.localizedDescription)
        }).disposed(by: bag)
    }
}
