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
    var repository: Repository?
    
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
    
    init(_ repository: Repository) {
        self.repository = repository
    }
    
    
}
