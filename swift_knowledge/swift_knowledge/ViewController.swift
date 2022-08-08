//
//  ViewController.swift
//  swift_knowledge
//
//  Created by benwang on 2022/7/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit

class ViewController: UIViewController {


    /// 1.条款
    /// 2.颂拓涉及到的具体条款
    /// 3.中国法律的趋势

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: URL(string: "http://127.0.0.1:8022/oauth5")!))

        webView.configuration.userContentController.add(self, name: "masaik")
    }
    

    @IBAction func tappedOne(_ sender: Any) {

    }

    @IBAction func tappedTwo(_ sender: Any) {

        
    }

    @IBAction func tappedThree(_ sender: Any) {

    }
}

extension ViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }

}

