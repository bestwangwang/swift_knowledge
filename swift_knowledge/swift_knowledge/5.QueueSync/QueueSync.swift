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
}
