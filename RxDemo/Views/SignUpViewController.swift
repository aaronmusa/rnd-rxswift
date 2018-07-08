//
//  SignUpViewController.swift
//  RxDemo
//
//  Created by Aaron Musa on 07/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import UIKit
import RxSwift

class SignUpViewController: UIViewController {
    
    var viewModel: SignUpViewModel!

    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordtextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SignUpViewModel(repository: Repository.shared)
        
        emailTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.email).disposed(by: bag)
        passwordtextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.password).disposed(by: bag)
        
        viewModel.email.subscribe(onNext: { _ in
            self.errorMessageLabel.text = ""
        }).disposed(by: bag)
        
        viewModel.password.subscribe(onNext: { _ in
            self.errorMessageLabel.text = ""
        }).disposed(by: bag)
        
        //Cancel
        cancelButton.rx.tap.subscribe(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: bag)
        
        //SignUp
        signUpButton.rx.tap.subscribe(onNext: { _ in
            self.viewModel.signUp().subscribe(onNext: { (_ ) in
                self.presentHome()
            }, onError: { (error) in
                self.errorMessageLabel.text = error.localizedDescription
            }).disposed(by: self.bag)
        }).disposed(by: bag)
    }

}

extension SignUpViewController {
    func presentHome(){
        if let homeViewController = StoryBoard.main.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            present(homeViewController, animated: true, completion: nil)
        }
    }
}
