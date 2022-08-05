//
//  RxS.swift
//  swift_knowledge
//
//  Created by benwang on 2022/7/20.
//

import RxSwift
import Foundation


// Observalbe.flatmap数据流切换
class ObservabeSwitch {

    let disposeBag = DisposeBag()

    let clock = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

    let subject1 = BehaviorSubject<Bool>(value: false)

    let subject2 = PublishSubject<Int>()
    let subject3 = PublishSubject<Int>()

    var onlineObservable: Observable<Int>?


    func bind() {
        clock.subscribe { [weak self] event in

            self?.subject2.onNext(0)
            self?.subject3.onNext(1)
        }

        onlineObservable = subject1.debug()
            .flatMap { [unowned self] in
                $0
                ? self.subject2.map(Optional.some).asObservable()
                : .just(nil)
            }
            .compactMap { $0 }
            .share()

        onlineObservable?.subscribe { [unowned self] event in
            print("event: \(event)")
        }
        .disposed(by: disposeBag)
    }

    func tappedStop(_ sender: Any) {
        subject1.onNext(false)
    }

    func tappedSend(_ sender: Any) {
        subject1.onNext(true)
    }
}
