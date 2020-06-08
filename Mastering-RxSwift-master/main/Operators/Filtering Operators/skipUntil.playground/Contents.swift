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

// MARK: - skipUntil operator

// - Observable type을 인자로 받습니다. 이 Observable이 next이벤트를 전달하기 전까지 원본 옵저버블이 전달하는 이벤트를 무시합니다.
// - 이런 특징 떄문에 skipUntil operator의 인자로 전달하는 Observable을 트리거라고도 부릅니다.

import RxSwift
import UIKit

/*:
 # skipUntil
 */

let disposeBag = DisposeBag()

// - 첫번째 subject는 구독 후, 두번째 subject(trigger)는 트리거로 사용하겠습니다.
let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.skipUntil(trigger)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// - 아직 trigger로서의 subject가 요소를 방출하지 않았으므로, 원본 Observable의 요소 방출은 무시됩니다.
// - 1은 무시됩니다.
subject.onNext(1)

// - trigger로서의 subject가 이벤트를 방출한 뒤에는 subejct 원본 옵저버블의 요소가 구독자로 전달됩니다.
trigger.onNext(99)

// - trigger로서의 subject가 이ㅣ벤트를 방출한 이후의 원본 Observable의 방출하는 이벤트는 구독자에게 전달됩니다.
subject.onNext(2)
subject.onNext(3)
