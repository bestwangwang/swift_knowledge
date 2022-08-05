//
//  RxOverride.swift
//  swift_knowledge
//
//  Created by benwang on 2022/8/5.
//

import Foundation
import RxSwift

class OverrideReply {

    let subject = PublishSubject<Observable<String>>()

    let ob1 = PublishSubject<String>()
    let ob2 = PublishSubject<String>()
    let ob3 = PublishSubject<String>()



    func action() {

        subject.asObservable()
            .map { Observable.concat($0, self.ob1.asObservable()) }
            .startWith(self.ob1.asObservable())
        //            .switchLatest()
            .flatMap { $0 }
            .subscribe(onNext: {
                print("switchLatest: \($0)")
            })
            .disposed(by: disposeBag)


        //        let ob1 = Observable.just(1)
        //        let ob2 = Observable<Int>.empty()
        //        let ob3 = Observable.just(3)
        //
        //        Observable.just(ob2)
        //            .map {
        //                Observable.concat($0, ob3)
        //            }
        //            .startWith(ob1)
        //            .switchLatest()
        //            .subscribe(
        //                onNext: {
        //                    print("ob: \($0)")
        //                }
        //            )
        //            .disposed(by: disposeBag)

        
    }


    
}
