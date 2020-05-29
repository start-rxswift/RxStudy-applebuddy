//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

// MARK: - CombineLatest

// MARK: CombineLatest

import RxSwift
import UIKit

/*:
 # combineLatest
 */

let bag = DisposeBag()

enum MyError: Error {
    case error
}

let greetings = PublishSubject<String>()
let languages = PublishSubject<String>()

// combineLatest는 두개의 옵저버블과 클로져를 parameter로 받습니다.
Observable.combineLatest(greetings, languages) { lhs, rhs -> String in
    "\(lhs) \(rhs)"
}
.subscribe { print($0) }
.disposed(by: bag)

// greetings, languages에서 next 이벤트를 전달하면 두 문자열을 합ㅈ친 Hi World! 가 출력됩니다.
greetings.onNext("Hi")
languages.onNext("World!")
// Hi World!

greetings.onNext("Hello")
languages.onNext("RxSwift")
// Hello RxSwift

greetings.onCompleted()
// greetings.onError(MyError.error) // 어느 한 옵저버블에서라도 에러 이벤트가 전달되면 그 즉시 구독자에게 error 이벤트를 전달하고 종료합니다. 그러므로 그 이후의 옵저버블은 구독자에게 전달되지 않습니다.

languages.onNext("SwiftUI")
// Hello SwiftUI

languages.onCompleted()
// 모든 Observable이 completed() 이벤트를 전달하면 이 시점에 구독자에게 completed 이벤트가 전달됩니다.
