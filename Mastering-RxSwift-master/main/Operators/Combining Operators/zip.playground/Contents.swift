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

// MARK: - ZIP Operator

// * 하나의 옵저버블이 갱신할 때마다, 가장 최신의 옵저버블들을 결합하던 combineLatest 연산자와는 달리, Zip 연산자를 사용하면 첫번째요소는 첫번쨰 요소끼리, 두번째요소는 두번째 요소끼리 결합합니다.

import RxSwift
import UIKit

/*:
 # zip
 */

let bag = DisposeBag()

enum MyError: Error {
    case error
}

let numbers = PublishSubject<Int>()
let strings = PublishSubject<String>()

Observable.zip(numbers, strings) { "\($0) - \($1)" }
    .subscribe { print($0) }
    .disposed(by: bag)

numbers.onNext(1)
strings.onNext("one") // 1 - one

numbers.onNext(2)
numbers.onNext(3)
strings.onNext("two") // 2 - two
strings.onNext("three") // 3 = three

// numbers subject에 completed 이벤트를 전달하고, strings subject에는 새로운 next 이벤트를 전달하겠습니다.
numbers.onNext(4)

// * 어느 하나 라도 도중 error 이벤트를 전달하면 그 즉시 구독자에게 error 이벤트를 전달 후 작업을 종료합니다.
// numbers.onError(MyError.error)

numbers.onCompleted()
strings.onCompleted()
// * 최종적으로 구독자에게 completed 이벤트가 전달됩니다.
strings.onNext("four") // 구독자에게 completed 이벤트가 전달 된 후의 observable은 무시됩니다.

// 구독자로 completed 이벤트가 전달되는 시점은 모든 observable이 completed 이벤트를 전달한 시점입니다.
