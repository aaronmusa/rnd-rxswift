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

    @IBOutlet weak var signOutButton: UIButton!
    var viewModel: HomeViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel(Repository.shared)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewModel.hasUserLoggedIn.bind { (loggedIn) in
            if loggedIn == false {
                if let loginViewController = StoryBoard.main.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
        }.disposed(by: bag)
    }
}

