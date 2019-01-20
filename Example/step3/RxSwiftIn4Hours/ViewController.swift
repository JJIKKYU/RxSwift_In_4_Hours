//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI

    private func bindUI() {
        idField.rx.text
            .map { [weak self] text -> Bool in
                if let text = text, self?.checkEmailValid(text) ?? false  { return true }
                return false
            }
            .bind(to: idValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
        pwField.rx.text
            .map { [weak self] text -> Bool in
                if let text = text, self?.checkPasswordValid(text) ?? false  { return true }
                return false
            }
            .bind(to: pwValidView.rx.isHidden)
            .disposed(by: disposeBag)
        
        // id input +--> check valid --> bullet
        //          |
        //          +--> button enable
        //          |
        // pw input +--> check valid --> bullet
    }

    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
