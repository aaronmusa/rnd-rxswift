//
//  HomeViewModelTests.swift
//  RxDemoTests
//
//  Created by Aaron Musa on 07/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import RxDemo

class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel(MockRepository.shared)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        viewModel = nil
    }
    
    func testSignOut() {
        viewModel.signOut().subscribe(onNext: { (_ ) in
            XCTAssertTrue(true)
        }, onError: { (error) in
            let err = error as NSError
            XCTFail(err.userInfo["message"] as! String)
        }).disposed(by: bag)
    }
    
}
