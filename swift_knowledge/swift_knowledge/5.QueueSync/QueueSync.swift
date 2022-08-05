//
//  QueueSync.swift
//  swift_knowledge
//
//  Created by benwang on 2022/8/5.
//

import Foundation

/// 该问题来自于 MDSKit 里 SubscriptionSet 中的 lockQueue
/// 结论：利用串行队列的同步任务，实现锁的功能，保证线程安全

class QueueSync {

    let lockQueue = DispatchQueue(label: "com.suunto.mdskit.device-service-lock", qos: .utility)


    func action() {

        var number = 100

        let queue = DispatchQueue(label: "dd")


        DispatchQueue.global().async {
            for _ in 0...10000 {
                queue.sync {
                    print("-: \(Thread.current)")
                    print("-: \(number)")
                    sleep(1)
                    number -= 1
                    print("-: \(number)")
                }
            }
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
            for _ in 0...10000 {
                queue.sync {
                    print("+: \(Thread.current)")
                    print("+: \(number)")
                    sleep(1)
                    number += 1
                    print("+: \(number)")
                }
            }
        })
    }


    func playground() {
        
        let countHandler: (Int) -> Void = { index in
            print(index)
        }

        let nameHandler: (String) -> Void = { name in
            print(name)
        }

        var set = SubscriptionSet()

        set.addSubscription(subscriber: countHandler)
        set.addSubscription(subscriber: nameHandler)

        set.forEach {
            $0.subscriber(10)
        }

        set.forEach {
            $0.subscriber("name")
        }
    }
}

struct Subscription<Event> {
    let subscriber: (Event) -> Void
    private let id: String = UUID().uuidString
}

extension Subscription: Hashable {


    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SubscriptionSet {

    var subscriptions = Set<AnyHashable>()
    var count: Int { subscriptions.count }

    mutating func insert<T: Hashable>(_ subscription: T) {
        _ = subscriptions.insert(subscription)
    }

    mutating func remove<T: Hashable>(_ subscription: T) {
        _ = subscriptions.remove(subscription)
    }
}

extension SubscriptionSet {

    mutating func addSubscription<Event>(subscriber: @escaping (Event) -> Void) {
        insert(Subscription(subscriber: subscriber))
    }

    func forEach<Event>(_ body: (Subscription<Event>) -> Void) {
        let matchs = subscriptions.compactMap {
            $0.base as? Subscription<Event>
        }

        matchs.forEach(body)
    }
}
