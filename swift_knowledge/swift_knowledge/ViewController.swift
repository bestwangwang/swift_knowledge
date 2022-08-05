//
//  ViewController.swift
//  swift_knowledge
//
//  Created by benwang on 2022/7/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {

    

    

    /// 1.条款
    /// 2.颂拓涉及到的具体条款
    /// 3.中国法律的趋势


    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    

    @IBAction func tappedOne(_ sender: Any) {
    }

    @IBAction func tappedTwo(_ sender: Any) {

        
    }

    @IBAction func tappedThree(_ sender: Any) {
        // tokenable = false
//        shareSymbol()
        transformOperators()
    }
}

let numbers = PublishSubject<Int>()

extension ViewController {

    func transformOperators() {

        numbers.asObservable()
            .toArray()
            .subscribe(onSuccess: {
                dump(type(of: $0))
                dump($0)
            })
            .disposed(by: disposeBag)

        numbers.onNext(1)
        numbers.onNext(2)
        numbers.onNext(3)
        numbers.onCompleted()
    }

    

    

}

