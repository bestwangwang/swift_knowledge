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

    var messageDispose = MessageDispose()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tappedSend(_ sender: Any) {
        /// 可以是任意类型的数据
        let handler: (String, Int) -> Void = {
            print("\($0)--\($1)")
        }

        MessageManager.addMessage(handler).dispose(by: messageDispose)

        let handle2: (String) -> Void = {
            print("\($0)")

        }
        MessageManager.addMessage({ (a: String) in
            print(a)
        }).dispose(by: messageDispose)

        let abc = MessageManager.addMessage({ (men: String) in
            print("折叠屏幕很好用啊，机械键盘真的很牛叉，托多的好用，声音很哈听India那个以打算您覅了掉地诶接覅 ID爱上大姐夫 打死来看待举 ")
        })







        MessageManager.addMessage(handle2).dispose(by: messageDispose)
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
