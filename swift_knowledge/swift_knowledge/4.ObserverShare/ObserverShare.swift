//
//  ObserverShare.swift
//  swift_knowledge
//
//  Created by benwang on 2022/8/5.
//

import Foundation
import RxSwift

class ObserverShare {

    var disposeBag  = DisposeBag()

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
    
}
