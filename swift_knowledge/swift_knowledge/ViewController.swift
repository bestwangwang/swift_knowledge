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

    var disposeBag  = DisposeBag()
    var disposable: Disposable?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    var number = 0

    @IBAction func tappedOne(_ sender: Any) {
        simultaneousCase()
    }

    @IBAction func tappedTwo(_ sender: Any) {
        onebyoneCase()
    }

    @IBAction func tappedThree(_ sender: Any) {
        tokenable = false
    }
}

extension ViewController {

    /// 同时异步请求
    /// 测试是否重复刷新token
    func simultaneousCase() {
        number = number + 1

        LogicService.shared.request(url: "R\(number)")//.debug()
            .subscribe(onSuccess: { ret in
                print("request token: \(ret) \(Thread.current)")
            })
            .disposed(by: disposeBag)


        number = number + 1

        LogicService.shared.request(url: "R\(number)")//.debug()
            .subscribe(onSuccess: { ret in
                print("request token: \(ret) \(Thread.current)")
            })
            .disposed(by: disposeBag)


        number = number + 1

        LogicService.shared.request(url: "R\(number)")//.debug()
            .subscribe(onSuccess: { ret in
                print("request token: \(ret) \(Thread.current)")
            })
            .disposed(by: disposeBag)
    }

    /// 依次请求接口
    /// 测试正在刷新时，是否会等待刷新完毕后再请求
    func onebyoneCase() {
        number = number + 1

        LogicService.shared.request(url: "R\(number)")//.debug()
            .subscribe(onSuccess: { ret in
                print("request token: \(ret) \(Thread.current)")
            })
            .disposed(by: disposeBag)


        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.number = self.number + 1

            LogicService.shared.request(url: "R\(self.number)")//.debug()
                .subscribe(onSuccess: { ret in
                    print("request token: \(ret) \(Thread.current)")
                })
                .disposed(by: self.disposeBag)
        }


        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.number = self.number + 1
            
            LogicService.shared.request(url: "R\(self.number)")//.debug()
                .subscribe(onSuccess: { ret in
                    print("request token: \(ret) \(Thread.current)")
                })
                .disposed(by: self.disposeBag)
        }
    }

}

