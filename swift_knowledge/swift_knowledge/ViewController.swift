//
//  ViewController.swift
//  swift_knowledge
//
//  Created by benwang on 2022/7/14.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftCommunity

class ViewController: UIViewController {

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
//        token?.onCancel()

        


    }


}

















/// 1.条款
/// 2.颂拓涉及到的具体条款
/// 3.中国法律的趋势
///
