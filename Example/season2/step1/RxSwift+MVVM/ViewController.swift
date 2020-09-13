//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    // Observable의 생명주기
    // 1. Create
    // 2. Subscribe
    // 3. onNext
    // ---- 끝 ---- (한번 Completed가 되거나 Error가 발생이 된다면 재사용이 불가능하다)
    // 4. onCompleted     /   onError
    // 5. Disposed
    
    func downloadJson(_ url : String) -> Observable<String?> {
        
        return Observable.from(["Hello", "World"]) // sugar api
        
//        return Observable.create() { emitter in
//            emitter.onNext("Hello World")
//            emitter.onCompleted()
//
//            return Disposables.create()
//        }
    }
    
//    func downloadJson(_ url : String) -> Observable<String?> {
//        // 1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
//        return Observable.create() { f in
//            DispatchQueue.global().async {
//                let url = URL(string: MEMBER_LIST_URL)!
//                let data = try! Data(contentsOf: url)
//                let json = String(data: data, encoding: .utf8)
//
//                DispatchQueue.main.async {
//                    f.onNext(json)
//                    f.onCompleted() // 순환참조 문제 해결
//                }
//
//                }
//            return Disposables.create()
//        }
//
//
//    }

    // MARK: SYNC

    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBAction func onLoad() {
        editView.text = ""
        self.setVisibleWithAnimation(self.activityIndicator, true)
        
        // Subscribe가 붙어야지 실행이 된다
        
        // 2. Observable로 오는 데이터를 받아서 처리하는 방법
        // observable은 disposable을 리턴한다
        _ = downloadJson(MEMBER_LIST_URL)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance) // super : operator
            .subscribe(onNext: { json in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            })
        
        
        // 필요에 따라서 호출해서 취소시킬 수 있음
//        disposable.dispose()
            
    }
}

