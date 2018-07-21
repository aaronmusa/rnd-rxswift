//
//  TableViewSampleViewController.swift
//  RxDemo
//
//  Created by Aaron Musa on 21/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TableSampleViewModel {
    
    var repository: RepositoryProtocol!
    
    var privateDataSource = BehaviorRelay<[String]>(value: ["Apple", "Grapes"])
    private let bag = DisposeBag()
    
//    var dataSource: Observable<[String]> {
////        return Observable.just(privateDataSource.value)
//        return Observable.just([]).bind(to: privateDataSource)
////        return Observable.create({ observer in
////            observer.onNext(self.privateDataSource.value)
////
////            return Disposables.create()
////        })
//    }
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    
    
}
