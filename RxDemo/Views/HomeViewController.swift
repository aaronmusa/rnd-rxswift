//
//  ViewController.swift
//  RxDemo
//
//  Created by Aaron Musa on 01/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet weak var exploreMapButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    var viewModel: HomeViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel(Repository.shared)
        
        signOutButton.rx.tap.subscribe(onNext: { _ in
            self.viewModel.signOut()
//            self.viewModel.signOut().subscribe(onNext: { (_ ) in
//                self.presentLogin()
//            }, onError: { (error) in
//                print(error.localizedDescription)
//            }).disposed(by: self.bag)
        }).disposed(by: bag)
        
        exploreMapButton.rx.tap.subscribe(onNext: { _ in
            self.presentMap()
        }).disposed(by: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewModel.hasUserLoggedIn.bind { (loggedIn) in
            if loggedIn == false {
                self.presentLogin()
            }
        }.disposed(by: bag)
        
        viewModel.observeCurrentSession().subscribe(onNext: { (device) in
            if device == nil {
                self.presentLogin()
            }
        }).disposed(by: bag)
    }
}

extension HomeViewController {
    func presentLogin() {
        if let loginViewController = StoryBoard.main.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
    
    func presentMap() {
        if let nav = StoryBoard.map.instantiateViewController(withIdentifier: "MapViewController") as? UINavigationController {
            if let _ = nav.viewControllers.first as? MapViewController {
                show(nav, sender: self)
            }
        }
    }
}
