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

// MARK: - amb

// - amb를 사용하면 가장 빠른 응답을 한 옵저버블 subject에 대해서만 응답처리를 하도록 할 수 있습니다.

import RxSwift
import UIKit

/*:
 # amb
 */

let bag = DisposeBag()

enum MyError: Error {
    case error
}

let a = PublishSubject<String>()
let b = PublishSubject<String>()
let c = PublishSubject<String>()

// a.amb(b)
Observable.amb([a, b, c])
    .subscribe { print($0) }
    .disposed(by: bag)

// a subject가 b subject보다 옵저버블을 먼저 방출했습니다. 그래서 amb는 a subject를 구독하고 b는 무시합니다.
// c.onNext("C")
a.onNext("A")
b.onNext("B")

// b subject의 이후의 이벤트도 무시되며 구독자에게 전달되지 않습니다.
b.onCompleted()

// 반면 a subject에 대한 이벤트는 구독자에게 전답됩니다.
a.onCompleted()

// c.onError(MyError.error)
