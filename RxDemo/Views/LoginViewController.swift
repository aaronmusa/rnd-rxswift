//
//  LoginViewController.swift
//  RxDemo
//
//  Created by Aaron Musa on 01/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LoginViewModel(repository: Repository.shared)
        
        emailTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.email).disposed(by: bag)
        passwordTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.password).disposed(by: bag)
        
        viewModel.isValid.bind(to: loginButton.rx.isEnabled).disposed(by: bag)
        
        viewModel.isValid.subscribe(onNext: { [unowned self] isValid in
            self.errorMessageLabel.text = isValid ? "Enabled" : "Not Enabled"
        }).disposed(by: bag)
        
        loginButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.viewModel.signIn().bind(onNext: { (user) in
                if let viewController = StoryBoard.main.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                    self.present(viewController, animated: true, completion: nil)
                }
            }).disposed(by: self.bag)
        }).disposed(by: bag)
    }
}
