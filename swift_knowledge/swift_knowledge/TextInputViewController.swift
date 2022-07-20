//
//  TextInputViewController.swift
//  swift_knowledge
//
//  Created by benwang on 2022/7/20.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

let kScreenWidth = UIScreen.main.bounds.size.width

class TextInputViewController: UIViewController {

    private var bottomConstraintForSignupLoginView: Constraint?

    let disposeBag = DisposeBag()

    var contentView = UIView()
    var textField1 = UITextField(frame: .zero)
    var textField2 = UITextField(frame: .zero)
    var textField3 = UITextField(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()


//        view.addSubview(contentView)
//        contentView.backgroundColor = .systemIndigo
//        contentView.snp.makeConstraints { make in
//            make.left.right.top.equalToSuperview()
//            bottomConstraintForSignupLoginView = make.bottom.equalToSuperview().constraint
//        }

        let scrollView = UIScrollView()
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            bottomConstraintForSignupLoginView = make.bottom.equalToSuperview().constraint
        }


        let maxHeight: CGFloat = 800

        scrollView.addSubview(contentView)
        contentView.backgroundColor = .systemIndigo
        contentView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.height.equalTo(maxHeight)
            make.width.equalTo(kScreenWidth)
//            make.edges.equalTo(scrollView.l)
        }

        scrollView.contentSize = CGSize(width: kScreenWidth, height: maxHeight)

        textField1.backgroundColor = .red
        textField2.backgroundColor = .green
        textField3.backgroundColor = .yellow

        contentView.addSubview(textField1)
        contentView.addSubview(textField2)
        contentView.addSubview(textField3)

        textField1.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalTo(textField2.snp.top).offset(-80)
        }

        textField2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
            make.centerY.equalToSuperview()
        }

        textField3.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
            make.top.equalTo(textField2.snp.bottom).offset(80)
        }

        textField3.textContentType = .name
        textField3.autocorrectionType = .no
        textField3.autocapitalizationType = .none

        let label = UILabel()
        label.text = "validate password"

        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(textField3)
            make.top.equalTo(textField3.snp.bottom).offset(2)
        }

        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification, object: nil).withUnretained(self)
            .subscribe(onNext: { strongSelf, notification in

                guard let keyboardYInScreenCoordinates = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.origin.y else { return }

                let viewBottomInScreenCoordinates = strongSelf.view.convert(CGPoint(x: 0, y: strongSelf.view.bounds.maxY), to: UIScreen.main.coordinateSpace).y

                let signupLoginViewBottomInset = viewBottomInScreenCoordinates - keyboardYInScreenCoordinates

                //                strongSelf.bottomConstraint.constant = signupLoginViewBottomInset

                strongSelf.updateBottomConstraintForSignupLoginView(inset: signupLoginViewBottomInset)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification, object: nil)
            .subscribe(onNext: { [weak self] _ in

                //                self?.bottomConstraint.constant = 0

                self?.updateBottomConstraintForSignupLoginView(inset: 0)
            })
            .disposed(by: disposeBag)

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tap)
    }

    @objc func tapped() {
        view.endEditing(true)
    }

    private func updateBottomConstraintForSignupLoginView(inset: CGFloat) {
        bottomConstraintForSignupLoginView?.update(inset: inset)
        view.layoutIfNeeded()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
