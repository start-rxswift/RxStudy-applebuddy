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

// MARK: - takeLast operator

// - 정수는 parameter로 받아서 Observable을 반환합니다.
// - 반환하는 Observable은 정수로 받은 parameter만큼의 마지막 요소들을 가집니다.

import RxSwift
import UIKit

/*:
 # takeLast
 */

enum MyError: Error {
    case error
}

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

let subject = PublishSubject<Int>()

// - takeLast는 가장 최근의 요소를 갖는 Observable을 반환합니다.
// ex) 8, 9, 10 을 갖는 Observable을 반환합니다. 바로 방출하지 않으며 completed 이벤트가 발생하기 전까지 방출을 지연시킵니다.
subject.takeLast(3)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

numbers.forEach { subject.onNext($0) }

// - 11이벤트를 전달받으며 Observable의 요소는 9, 10, 11로 갱신됩니다.
subject.onNext(11)

// - completed 이벤트가 전달되면서 9, 10, 11 요소를 방출합니다.
// ex) 9, 10, 11, completed
subject.onCompleted()

// - 만약 completed 이벤트 대신 error 이벤트를 전달받으면 갖고 있던 요소들은 방출하지 않으며, error 이벤트만 구독자에게 전달됩니다.
// ex) error(error)
// subject.onError(MyError.error)
