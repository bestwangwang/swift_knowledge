//
//  SubscriptionSet.swift
//  swift_knowledge
//
//  Created by benwang on 2022/8/5.
//

import Foundation

///
///
///

func test() {
    let countHandler: (Int) -> Void = { index in
        print(index)
    }

    let nameHandler: (String) -> Void = { name in
        print(name)
    }

    var bumb = Bumb()

    let cancelable1 = bumb.addSubscription(countHandler)
    let cancelable2 = bumb.addSubscription(nameHandler)

    bumb.notify(of: 10)
    bumb.notify(of: "name")
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

    func forEach<Event>(_ body: (Subscription<Event>) -> Void) {
        let matchs = subscriptions.compactMap {
            $0.base as? Subscription<Event>
        }

        matchs.forEach(body)
    }
}

struct Cancelable {
    let onCancel: () -> Void

    func cancel() {
        onCancel()
    }
}

class Bumb {

    var subscriptions = SubscriptionSet()

    func addSubscription<Event>(_ subscriber: @escaping (Event) -> Void) -> Cancelable {
        let subscription = Subscription(subscriber: subscriber)

        subscriptions.insert(subscription)

        let cancelable = Cancelable { [weak self] in
            self?.subscriptions.remove(subscription)
        }

        return cancelable
    }

    func notify<T>(of value: T) {
        subscriptions.forEach {
            $0.subscriber(value)
        }
    }
}
