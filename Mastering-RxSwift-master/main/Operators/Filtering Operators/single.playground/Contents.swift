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

// MARK: - single operator

// - 요소 중 맨 처음 하나의 요소만 방출합니다.

import RxSwift
import UIKit

/*:
 # single
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// result) next(1), completed
Observable.just(1)
    .single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// - single() 연산자를 사용할 때는 단 하나의 요소만 전달되야 합니다. 원본 옵저버블이 0, 2~ 개의 값을 방출하면 안됩니다.
// result) next(1)이 방출 되지만, error 이벤트가 발생합니다.(Sequence contains more than one element.)
Observable.from(numbers)
    .single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// - single 연산자가 단 하나의 요소만 전달할 수 있도록 predicate 클로져 조건을 두었을때 단 하나의 요소만 충족된다면 성립되어 단 하나의 요소를 전달할 수 있습니다.
Observable.from(numbers)
    .single { $0 == 6 }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

let subject = PublishSubject<Int>()
subject.single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// - 하나의 Int 요소를 subject에서 방출하면 바로 구독자에게 해당 요소가 전달됩니다. single 연산자는 subject가 completed 이벤트가 발생하기 전까지 단 하나의 요소만 방출하지 않는다면 error 이벤트를 방출하게 됩니다.
// - 이런 single 연산자의 특성으로 하나의 요소만 방출되는 것을 보장할 수 있습니다.
subject.onNext(100)

// - 해당 시점에 onCompleted 이벤트를 전달받으면, 이전까지 방출된 요소는 단 하나이므로 정상적으로 completed 이벤트를 구독자에게 전달합니다.
subject.onCompleted()

// - completed 이벤트 이전에 두개 이상의 요소가 방출되었으므로, error이벤트가 발생합니다.
// subject.onNext(99)
