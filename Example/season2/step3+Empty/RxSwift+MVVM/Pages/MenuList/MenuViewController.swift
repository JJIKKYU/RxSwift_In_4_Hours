//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    // MARK: - Life Cycle
    
    let cellId = "MenuItemTableViewCell"
    
    let viewModel = MenuListViewModel()
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = nil
        
        viewModel.menuObservable
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: MenuItemTableViewCell.self)) { index, item, cell in
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
                
                cell.onChange = { [weak self] increase in
                    self?.viewModel.changeCount(item: item, increase: increase)
                }
        }
            .disposed(by: disposeBag)
        
//        viewModel.itemsCount
//            .map { "\($0)"}
//            .catchErrorJustReturn("") // 에러가 난다면 빈 문자열을 리턴해
//            .observeOn(MainScheduler.instance)
//            .bind(to: itemCountLabel.rx.text)
//            .disposed(by: disposeBag)
 
        // Drive는 항상 메인 쓰레드에서 작동하고, error 리턴값을 만들어줌
        viewModel.itemsCount
            .map { "\($0)"}
            .asDriver(onErrorJustReturn: "")
            .drive(itemCountLabel.rx.text)
            .disposed(by: disposeBag)
            
        // 순환참조 없이 들어오는 값을 그대로 들어가게 할 수 있도록 만들 수 있음
        viewModel.totalPrice
            .map { $0.currencyKR() }
            .observeOn(MainScheduler.instance) // 위에서 어떤 쓰레드에서 처리하든지, 메뉴는 메인 쓰레드에서
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            // TODO: pass selected menus
        }
    }

    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!

    @IBAction func onClear() {
        viewModel.clearAllItemSelections()
    }

    @IBAction func onOrder(_ sender: UIButton) {
        // TODO: no selection
        // showAlert("Order Fail", "No Orders")
//        performSegue(withIdentifier: "OrderViewController", sender: nil)
        viewModel.onOrder()
    }
}
