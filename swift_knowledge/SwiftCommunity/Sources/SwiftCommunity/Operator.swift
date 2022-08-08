//import Foundation
//
//infix operator <^>: AdditionPrecedence
//
//infix operator <*>: AdditionPrecedence
//
//
//// MARK: - Functor
//
//// map
//public func <^><T, U>(f: (T) -> U, a: T?) -> U? {
//  a.map(f)
//}
//
//// MARK: - Applicatives
//
//// mapd
//public func <*><T, U>(fs: ((T) -> U)?, a: T?) -> U? {
//  switch fs {
//    case let .some(f): return a.map(f)
//    case .none: return .none
//  }
//}
//
//
