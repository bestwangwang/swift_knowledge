//
//  File.swift
//  
//
//  Created by benwang on 2022/7/29.
//

import Foundation
import RxSwift
import RxRelay

// MARK: - RxSwift

let disposeBag = DisposeBag()

//let observable = Observable.of(1, 2, 3, 4, 5, 6)
//let observable = Observable<Int>.create { observer in
//    observer.onNext(1)
//    return Disposables.create()
//}

//let observable = BehaviorSubject<Void>(value: ())
//
//observable.subscribe(
//    onNext: {
//        print("onCompleted")
//    }
//).disposed(by: disposeBag)

let obmerage = RxMerage()
obmerage.observable.subscribe { res in
    print("这是结果 \(res)")
} onError: { error in

} onCompleted: {

} onDisposed: {

}
.disposed(by: disposeBag)

obmerage.emit()

//observable.subscribe(
//    onNext: {
//        print($0)
//    },
//    onError: {
//        print($0)
//    },
//    onCompleted: {
//        print("onCompleted")
//    },
//    onDisposed: {
//        print("onDisposed")
//    }
//).disposed(by: disposeBag)


let ls = [1,2,3,4,5]

let a = ls.sorted { $0 < $1 }.first

// MARK: - SubscriptionSet


//let countHandler: (Int) -> Void = { index in
//    print(index)
//}
//
//let nameHandler: (String) -> Void = { name in
//    print(name)
//}
//
//var bumb = Bumb()
//
//let cancelable1 = bumb.addSubscription(countHandler)
//let cancelable2 = bumb.addSubscription(nameHandler)
//
//bumb.notify(of: 10)
//bumb.notify(of: "name")


// MARK: - Operator


//struct Post { var title: String }
//
//func findPost(_ id: Int) -> Post? {
//  return Post(title: "haoe")
//}
//
//func getPostTitle(_ post: Post) -> String {
//  return post.title
//}
//
//
//let title = findPost(1).map(getPostTitle)
//
//
//let title1 = getPostTitle <^> findPost(1)
//
//
//
//print(title)
//
//print(title1)
//
//
//
//func curriedAddition(a: Int) -> (Int) -> Int {
//  return { $0 + a }
//}
//
//let abc = curriedAddition <^> Optional(2) <*> Optional(3)
//
////let cde = abc <*> Optional(3)
//
//
//print("\(abc)")
//
//
//struct Name: Hashable {
//  var name: String
//}
//
//typealias DictionaryIN = Dictionary<Name Int>

dispatchMain()

