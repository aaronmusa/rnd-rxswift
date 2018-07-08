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

    @IBOutlet weak var signUpButton: UIButton!
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
        
        viewModel.email.subscribe(onNext: { _ in
            self.errorMessageLabel.text = ""
        }).disposed(by: bag)
        
        viewModel.password.subscribe(onNext: { _ in
            self.errorMessageLabel.text = ""
        }).disposed(by: bag)
        
        loginButton.rx.tap.subscribe(onNext: { _  in
            self.viewModel.signIn().subscribe(onNext: { (_ ) in
                if let viewController = StoryBoard.main.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                    self.present(viewController, animated: true, completion: nil)
                }
            }, onError: { (error) in
                self.errorMessageLabel.isHidden = false
                self.errorMessageLabel.text = error.localizedDescription
            }).disposed(by: self.bag)
        }).disposed(by: bag)
        
        signUpButton.rx.tap.subscribe(onNext: { _ in
            //if let nav = StoryBoard.main.instantiateViewController(withIdentifier: "SignUpViewController") as? UINavigationController {
                if let signUpViewController = StoryBoard.main.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
                    self.show(signUpViewController, sender: self)
//                    self.present(signUpViewController, animated: true, completion: nil)
                }
            //}
        }).disposed(by: bag)
    }
}
