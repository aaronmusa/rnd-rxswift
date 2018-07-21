//
//  TableSampleViewController.swift
//  RxDemo
//
//  Created by Aaron Musa on 21/07/2018.
//  Copyright © 2018 Aaron Musa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TableSampleViewController: UIViewController {

    @IBOutlet weak var fruitsTableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    let bag = DisposeBag()
    
    var viewModel: TableSampleViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TableSampleViewModel(repository: Repository.shared)
        
        addButton.rx.tap.subscribe({ _ in
           self.viewModel.privateDataSource.accept(self.viewModel.privateDataSource.value + ["test"])
        }).disposed(by: bag)
        
        viewModel.privateDataSource.bind(to: fruitsTableView.rx.items(cellIdentifier: "FruitCell", cellType: UITableViewCell.self)){ row, element, cell in
            cell.textLabel?.text = "\(element) \(row)"
        }.disposed(by: bag)
        
        fruitsTableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print(indexPath)
        }).disposed(by: bag)
    }
}
