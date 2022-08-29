//
//  RxMerage.swift
//  
//
//  Created by benwang on 2022/8/17.
//

import Foundation
import RxSwift

class RxMerage {
    private let pb1 = PublishSubject<Int>()
    private let pb2 = PublishSubject<Int>()
    private let pb3 = PublishSubject<Int>()

    var observable: Observable<Int> {
        Observable.merge([pb1, pb2, pb3])
            .flatMap { rs -> Observable<Int> in
                print("这是嘛？\(rs)")
                return Observable.create { obs in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        obs.onNext(rs)
                    }
                    return Disposables.create {
                    }
                }
            }
    }

    func emit() {
        pb1.onNext(1)
        pb2.onNext(2)

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.pb3.onNext(1)
        }
    }
}
