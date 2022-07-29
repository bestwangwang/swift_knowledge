//
//  File.swift
//  
//
//  Created by benwang on 2022/7/29.
//

import Foundation
import RxSwift

let disposeBag = DisposeBag()

let observer = Observable.of(1, 2, 3, 4, 5, 6)

observer.subscribe(
    onNext: {
        print($0)
    },
    onError: {
        print($0)
    },
    onCompleted: {
        print("onCompleted")
    },
    onDisposed: {
        print("onDisposed")
    }
).disposed(by: disposeBag)

dispatchMain()
