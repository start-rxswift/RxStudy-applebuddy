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

// MARK: - takeUntil operator

// - trigger subject가 이벤트를 방출하기 전까지 원본 옵저버블의 이벤트를 방출합니다.
// - trigger subject가 이벤트를 방출 한 이후에는 원본 옵저버블에서 completed이벤트를 전달하며, 이후 방출하는 이벤트는 무시됩니다.

import RxSwift
import UIKit

/*:
 # takeUntil
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.takeUntil(trigger)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// - subject에서 방출하는 1, 2는 아직 trigger subject가 이벤트를 방출하기 전이므로 구독자에게 전달됩니다.
subject.onNext(1)
subject.onNext(2)

// - trigger subject가 next event를 방출 한 이후, completed 이벤트가 전달됩니다.
// - 이후 원본 subject Observable에서 방출되는 이벤트는 무시됩니다.
trigger.onNext(2)
subject.onNext(3)
