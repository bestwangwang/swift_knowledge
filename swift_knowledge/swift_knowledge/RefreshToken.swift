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

    static let lock = NSLock()
}

class LogicService {
    static let shared = LogicService()

    let taskQueue = DispatchQueue(label: "logic", attributes: .concurrent)

    let lock = NSRecursiveLock()

    func request(url: String) -> Single<String> {
        return Token.shared.refreshStatus
            .distinctUntilChanged()
            // 正在刷新的等待，丢弃信号
            .filter { !$0 }
            .first()
            // 请求业务接口
            .flatMap { _ in
                self._request(url: url)
            }
            // 接口数据处理
            .flatMap { data -> Single<String> in

                // 错误处理：Token过期
                // 需要刷新
                if data.isEmpty {

                    defer {
                        print("\(url) 解锁")
                        Token.lock.unlock()
                    }
                    print("\(url) 加锁")
                    Token.lock.lock()

                    // 没有刷新，则开始刷新
                    if !Token.shared.refreshStatus.value {
                        print("\(url) 准备刷新Token")
                        Token.shared.refreshStatus.accept(true)
                        return self._request(tag: url)
                            .flatMap { _ in
                                print("\(url) 刷新Token完毕")
                                Token.shared.refreshStatus.accept(false)
                                return self._request(url: url)
                            }
                    }
                    print("\(url) 未刷新Token，请求业务接口")
                    return self.request(url: url)
                }

                // 正确处理：结果透传
                return Single<String>.just(data)
            }
    }
}

extension LogicService {

    func _request(tag: String) -> Single<Bool> {
        return Single.create { [weak self] observer in
            let item = DispatchWorkItem {
                print("response: \(tag) Token刷新完毕")
                tokenable = true
                observer(.success(true))
            }
            print("request: \(tag) 正在刷新Token...")
            self?.taskQueue.asyncAfter(deadline: .now() + 1, execute: item)

            return Disposables.create {
                item.cancel()
            }
        }
    }

    func _request(url: String) -> Single<String> {
        return Single.create { [weak self] observer in

            let item = DispatchWorkItem {
                if tokenable {
                    print("response: 数据请求完毕：\(url)")
                    observer(.success(url))
                } else {
                    print("response：Token过期：\(url)")
                    observer(.success(""))
                }
            }

            print("request: 正在请求数据：\(url)")
            self?.taskQueue.asyncAfter(deadline: .now() + 1, execute: item)

            return Disposables.create {
                item.cancel()
            }
        }
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

