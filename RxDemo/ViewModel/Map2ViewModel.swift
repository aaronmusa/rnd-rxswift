//
//  Map2ViewModel.swift
//  RxDemo
//
//  Created by Aaron Musa on 22/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class Map2ViewModel {
    
    var repository: RepositoryProtocol!
    
    init(_ repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getRoute(_ origin: String, destination: String,
                  successHandler: @escaping ([JSON]) -> Void) {
        repository.getMapDirections(origin, destination, successHandler: { (routes) in
            successHandler(routes)
        }) { }
    }
}
