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
import SVGAPlayer

class ViewController: UIViewController {

    var messageDispose = MessageDispose()

    let storage = Storage()

    override func viewDidLoad() {
        super.viewDidLoad()

        let url1 = URL(string: "https://cd-user-upload.hongsong.club/panda/gift_guard.svga")
        storage.store(file: url1!)

        let svgPlayer = SVGAPlayer(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.addSubview(svgPlayer)

        let parser = SVGAParser.init()

        let url = URL(string: "https://cd-user-upload.hongsong.club/panda/gift_guard.svga")
        let svgaURL = storage.generate(file: url!)?.absoluteString
        print("HSLiveRoomSVAGEffectManager 读取本地资源地址:\(svgaURL)")
        if svgaURL!.starts(with: "file") { // 从本地加载
            let la = URL(string: svgaURL!)!
            let data = try? Data(contentsOf: la)
            if let giftData = data {
                parser.parse(with: giftData, cacheKey: "") {[weak self] videoEntity in
                    guard let self = self else { return }
                    svgPlayer.videoItem = videoEntity
                    svgPlayer.startAnimation()
                } failureBlock: { error in
                    print("HSLiveRoomSVAGEffectManager加载本地礼物资源失败:\(error.localizedDescription)")
                }
            } else {
                print("获取本地沙盒文件失败，从网络地址播放")
            }
        } else { // 从网络加载
        }
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
            print("折叠屏幕很好用啊，机械键 ")
        })

        MessageManager.addMessage(handle2).dispose(by: messageDispose)
    }

    @IBAction func tappedCancel(_ sender: Any) {
        /// 根据添加的类型匹配
        MessageManager.sendMessage(("China", 70))
        MessageManager.sendMessage("China")

        let url = URL(string: "https://cd-user-upload.hongsong.club/panda/gift_guard.svga")
        storage.store(file: url!)
    }

    @IBAction func tappedDispose(_ sender: Any) {
//        token?.onCancel()

        let url = URL(string: "https://cd-user-upload.hongsong.club/panda/gift_guard.svga")
        let data = storage.read(file: url!)
    }


}

















/// 1.条款
/// 2.颂拓涉及到的具体条款
/// 3.中国法律的趋势
///
