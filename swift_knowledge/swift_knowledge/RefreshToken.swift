//
//  RefreshToken.swift
//  swift_knowledge
//
//  Created by benwang on 2022/7/20.
//

import Foundation
import RxSwift
import RxRelay

struct Token {
    static let shared = Token()

    /// 是否正在刷新
    let refreshStatus = BehaviorRelay(value: false)
}

class LogicService {
    static let shared = LogicService()

    let disposeBag = DisposeBag()

    //    let refreshToken = Token.shared.refreshStatus.

    let taskQueue = DispatchQueue(label: "logic", attributes: .concurrent)

    let lock = NSRecursiveLock()

    func request(url: String) -> Single<String> {
        /// a b c
        /// a 请求
        return Token.shared.refreshStatus
            .distinctUntilChanged()
            // 正在刷新的等待，丢弃信号
            .filter {
                !$0
            }
            .first()
//            .map { _ in }
            // 请求业务接口
            .flatMap { _ in
                self._request(url: url)
            }
            // 接口数据处理
            .flatMap { data -> Single<String> in

                // 错误处理：Token过期
                // 需要刷新
                if data.isEmpty {
                    defer { self.lock.unlock() }
                    self.lock.lock()

                    // 没有刷新，则开始刷新
                    if !Token.shared.refreshStatus.value {
                        Token.shared.refreshStatus.accept(true)
                        return self._request()
                            .flatMap { _ in
                                Token.shared.refreshStatus.accept(false)
                                return self._request(url: url)
                            }
                    }
                    return self._request(url: url)
                }

                // 正确处理：结果透传
                return Single<String>.just(data)
            }
    }
}

extension LogicService {

    func _request() -> Single<Bool> {
        return Single.create { [weak self] observer in
            let item = DispatchWorkItem {
//                print("token: thread-\(Thread.current)")
                print("Token刷新完毕")
                tokenable = true
                observer(.success(true))
            }
            print("正在刷新Token...")
            self?.taskQueue.asyncAfter(deadline: .now() + 1, execute: item)

            return Disposables.create {
                item.cancel()
            }
        }
//        .observe(on: MainScheduler.instance)
    }

    func _request(url: String) -> Single<String> {
        return Single.create { [weak self] observer in

            let item = DispatchWorkItem {
                if tokenable {
                    //print("logic: thread-\(Thread.current)")
                    print("数据请求完毕：\(url)")
                    observer(.success(url))
                } else {
                    print("Token过期：\(url)")
                    observer(.success(""))
                }
            }

            print("正在请求数据：\(url)")
            self?.taskQueue.asyncAfter(deadline: .now() + 1, execute: item)

            return Disposables.create {
                item.cancel()
            }
        }
//        .observe(on: MainScheduler.instance)
    }
}

var tokenable: Bool {
    get {
        UserDefaults.standard.bool(forKey: "token")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "token")
    }
}

enum LogicError: Error {
    case invalidToken
}
