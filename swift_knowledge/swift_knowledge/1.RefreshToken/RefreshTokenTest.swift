//
//  RefreshTokenTest.swift
//  swift_knowledge
//
//  Created by benwang on 2022/8/5.
//

import Foundation
import RxSwift

class RefreshTokenTest {
    
    var disposeBag  = DisposeBag()

    var number = 0

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

func netWorking() -> Single<String>{
    return Single<String>.create { single in
        single(.success("贼帅"))
        print("我执行了")
        return Disposables.create()
    }
}
