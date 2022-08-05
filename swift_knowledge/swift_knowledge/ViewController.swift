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

    

    /// 1.条款
    /// 2.颂拓涉及到的具体条款
    /// 3.中国法律的趋势


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

    func shareSymbol(){
        let observable = netWorking().debug()
//            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .asObservable()
            .share()
//            .share(replay: 1)

        observable.subscribe(
            onNext: { content in
                print(content)
            }
        ).disposed(by: disposeBag)

        observable.subscribe(
            onNext: { content in
                print(content)
            }
        ).disposed(by: disposeBag)

        observable.subscribe(
            onNext: { content in
                print(content)
            }
        ).disposed(by: disposeBag)
    }

    func netWorking() -> Single<String>{
        return Single<String>.create { single in
            single(.success("贼帅"))
            print("我执行了")
            return Disposables.create()
        }
    }

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


        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.number = self.number + 1

            LogicService.shared.request(url: "R\(self.number)")//.debug()
                .subscribe(onSuccess: { ret in
                    print("request token: \(ret) \(Thread.current)")
                })
                .disposed(by: self.disposeBag)
        }


        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.number = self.number + 1
            
            LogicService.shared.request(url: "R\(self.number)")//.debug()
                .subscribe(onSuccess: { ret in
                    print("request token: \(ret) \(Thread.current)")
                })
                .disposed(by: self.disposeBag)
        }
    }

}

