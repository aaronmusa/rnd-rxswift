//
//  LoginViewModelTests.swift
//  RxDemoTests
//
//  Created by Aaron Musa on 07/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import RxDemo

struct ValidInputs {
    static let email = BehaviorRelay<String>(value: "aaron")
    static let password = BehaviorRelay<String>(value: "qqqqqq1")
}

struct InValidInputs {
    static let email = BehaviorRelay<String>(value: "qqq")
    static let password = BehaviorRelay<String>(value: "aaa")
}

class LoginViewModelTests: XCTestCase {
    
     var viewModel: LoginViewModel!
     var bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        viewModel = LoginViewModel(repository: MockRepository.shared)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        viewModel = nil
    }
    
    func testSignInSuccess(){
        viewModel.signIn().subscribe(onNext: { (_ ) in
            XCTAssertTrue(true)
        }, onError: { (error) in
            let err = error as NSError
            XCTFail(err.userInfo["message"] as! String)
        }).disposed(by: bag)
    }
    
    func testValidInputs() {
        
        let email = ValidInputs.email
        let password = ValidInputs.password
        
        let expectedResult = true
        var result: Bool!
        
        email.bind(to: viewModel.email).disposed(by: bag)
        password.bind(to: viewModel.password).disposed(by: bag)
        
        
        viewModel.isValid.bind { (isValid) in
            result = isValid
        }.disposed(by: bag)
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func testInvalidInputs() {
//        let scheduler = TestScheduler(initialClock: 0)
        let email = InValidInputs.email
        let password = InValidInputs.password
        
        let expectedResult = false
        var result: Bool!
        
        email.bind(to: viewModel.email).disposed(by: bag)
        password.bind(to: viewModel.password).disposed(by: bag)
        
        
        viewModel.isValid.bind { (isValid) in
            result = isValid
        }.disposed(by: bag)
        
        XCTAssertEqual(result, expectedResult)
        
//        let xs = scheduler.createHotObservable([
//            next(210, viewModel.isValid),  // first argument is virtual time, second argument is element value
//            completed(300) // virtual time when completed is sent
//            ])

//        let res = scheduler.start { xs.map { $0 } }
//
//        let correctMessages = [
//            next(210, expectedResult),
//            completed(300)
//        ]
//
//        let correctSubscriptions = [
//            Subscription(200, 300)
//        ]
        
//        XCTAssertEqual(res.events, correctMessages)
//        XCTAssertEqual(xs.subscriptions, correctSubscriptions)
        
    }
    
//    func testSignIn() {
//        let rxExpect = RxExpect()
//        let emailString
//
//    }

}
