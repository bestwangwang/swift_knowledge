//
//  FeaturesViewController.swift
//  swift_knowledge
//
//  Created by benwang on 2022/8/10.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI

typealias FeatureClosure = (name: String, handler: () -> AnyView)

class FeaturesViewController: UIViewController {

    var datasource = BehaviorRelay<[FeatureClosure]>(value: [])
    var tableView = UITableView()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Features"

        datasource.bind(to: tableView.rx.items) { tb, i, fc in
            let indexPath = IndexPath(row: i, section: 0)
            let cell = tb.dequeueReusableCell(withIdentifier: "c", for: indexPath)
            cell.textLabel?.text = fc.name
            return cell
        }
        .disposed(by: disposeBag)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "c")

        tableView.rx.modelSelected(FeatureClosure.self)
            .withUnretained(self)
            .subscribe(onNext: { obj, fc in
                let view = fc.handler()
                let vc = UIHostingController(rootView: view)
                obj.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }


        datasource.accept([
            ( "Bluetooth", { DiscoverDeviceView().eraser() }),
        ])
    }
}

extension View {
    func eraser() -> AnyView {
        AnyView(self)
    }
}
