//
//  MessageManager.swift
//  swift_knowledge
//
//  Created by benwang on 2022/8/12.
//

import Foundation
import UIKit

/**
 1. 消息管理：用于添加消息事件
 2. 消息池：存储消息
    - 添加消息
    - 移除消息
    - 检索指定消息并执行
 3. 消息：封装消息事件
 4. 取消：提供可取消的事件
 */

public class MessageToken {
    public let onCancel: () -> Void

    init(cancel: @escaping () -> Void) {
        onCancel = cancel
    }

    deinit {
        onCancel()
    }
}

fileprivate struct Message<Event> {
    var handler: (Event) -> Void
    private let identifier = UUID()
}

extension Message: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Message<Event>, rhs: Message<Event>) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

fileprivate struct MessagePools {
    var pools = Set<AnyHashable>()
    var count: Int { pools.count }

    mutating func insert<T: Hashable>(_ message: T) {
        _ = pools.insert(AnyHashable(message))
    }

    mutating func remove<T: Hashable>(_ message: T) {
        _ = pools.remove(AnyHashable(message))
    }
}

public class MessageManager {

    private static let shared = MessageManager()

    private var messagePools = MessagePools()

    public static func addMessage<Event>(_ handler: @escaping (Event) -> Void) -> MessageToken {
        let message = Message(handler: handler)

        shared.messagePools.insert(message)

        return MessageToken { [weak shared] in
            shared?.messagePools.remove(message)
        }
    }

    public static func sendMessage<Event>(_ event: Event) {
        shared.messagePools.forEach { $0.handler(event) }
    }
}

extension MessagePools {
    func forEach<Event>(_ handler: (Message<Event>) -> Void) {
        let matchs = pools.compactMap {
            $0.base as? Message<Event>
        }
        matchs.forEach(handler)
    }
}

/// For Example:
/*

 var token1: MessageToken?

 var token2: MessageToken?

 override func viewDidLoad() {
     super.viewDidLoad()
 }

 @IBAction func tappedSend(_ sender: Any) {
     /// 可以是任意类型的数据
     let handler: (String, Int) -> Void = {
         print("\($0)--\($1)")
     }

     token1 = MessageManager.addMessage(handler)

     let handle2: (String) -> Void = {
         print("\($0)")
     }

     token2 = MessageManager.addMessage(handle2)
 }

 @IBAction func tappedCancel(_ sender: Any) {
     /// 根据添加的类型匹配
     MessageManager.sendMessage(("China", 70))
     MessageManager.sendMessage("China")
 }

 @IBAction func tappedDispose(_ sender: Any) {
    token?.onCancel()
 }

 */
