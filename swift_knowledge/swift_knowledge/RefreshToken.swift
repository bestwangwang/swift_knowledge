//
//  RefreshToken.swift
//  swift_knowledge
//
//  Created by benwang on 2022/7/20.
//

import Foundation
import RxSwift

struct Token {
    static let shared = Token()

    let refreshStatus = BehaviorSubject(value: false)


}

class LogicService {
    static let shared = LogicService()

//    let refreshToken = Token.shared.refreshStatus.

    let taskQueue = DispatchQueue(label: "logic", attributes: .concurrent)






    func _request(url: String, handler: @escaping (String) -> Void) -> Void {
//        taskQueue.asyncAfter(deadline: .now() + 1) {
//            handler(url)
//        }
    }
}
