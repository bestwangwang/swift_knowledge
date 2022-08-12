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

    /// 1.条款
    /// 2.颂拓涉及到的具体条款
    /// 3.中国法律的趋势

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tappedSend(_ sender: Any) {

    }

    @IBAction func tappedCancel(_ sender: Any) {

        var abc = parsedNameAndPairingIdFrom(localName: "Ambit3V #P1539195")
//        var abc = parsedNameAndPairingIdFrom(localName: "Spartan SportWHR 016411300074")

        print("\(abc?.name)")
        print("\(abc?.pairingId)")
    }

    @IBAction func tappedDispose(_ sender: Any) {
//        
//        navigationController?.pushViewController(BEEViewController(), animated: true)
    }
}

