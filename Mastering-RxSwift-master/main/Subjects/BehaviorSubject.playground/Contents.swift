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

// MARK: - BehaviorSubject

// - BehaviorSubject는 PublishSubject에 비해 subject를 생성하는 방식에 차이가 있습니다.

import RxSwift
import UIKit

/*:
 # BehaviorSubject
 */

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

// - PublishSubject를 생성하는 방법
// - PublishSubject는 이벤트를 전달받기 전까지는 구독자에게 어떠한 이벤트도 전달하지 않습니다.
let ps = PublishSubject<Int>()
ps.subscribe { print("PublisshSubject >>", $0) }
    .disposed(by: disposeBag)

// - BehaviorSubject를 생성하는 방법, 초기값이 존재
// - BehaviorSubject는 초기값이 있어, 이벤트를 전달받지 않았더라도, 구독자에게 초기값을 이벤트로 전달할 수 있습니다.
let bs = BehaviorSubject<Int>(value: 0)
bs.subscribe { print("BehaviorSubject >>", $0) } // BehaviorSubject >> next(0)
    .disposed(by: disposeBag)

// - BehaviorSubject는 새로운 이벤트를 전달 받으면 기존의 이벤트에서 새로운 이벤트로 교체합니다.
bs.onNext(1)

// 그래서 이후 BehaviorSubject를 구독하는 구독자는 새로운 이벤트를 전달받습니다.
bs.subscribe { print("BehaviorSubject2 >>", $0) }
    .disposed(by: disposeBag)

// BehaviorSubject에 completed 이벤트를 전달해 보겠습니다.
// 지금까지의 구독자들에게 completed 이벤트를 전달합니다. 이후의 구독자에게는 즉시 completed 이벤트를 전달합니다.
// error 이벤트도 동일합니다. 지금까지의 구독자들에게 error이벤트를 전달하고, 이후 구독자에게도 구독 즉시 error이벤트를 전달합니다.
bs.onCompleted()
// bs.onError(MyError.error)

// completed 가 된 이후의 BehaviorSubject를 구독하는 구독자는 구독 직후 completed 이벤트를 전달받습니다.
bs.subscribe { print("BehaviorSubject3 >>", $0) }
    .disposed(by: disposeBag)
