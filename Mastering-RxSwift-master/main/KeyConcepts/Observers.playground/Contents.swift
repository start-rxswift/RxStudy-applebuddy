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

// MARK: - Observers

// - Observer가 Observable을 감시하는 것을 구독(subscribe)한다고 표현합니다.
// - Observer를 구독자(subscriber)라고도 부릅니다.
// - Observable은 Observer로 next이벤트를 전달하는데 이를 방출(Emission)이라고 부릅니다.
// - Observable에서 Error, Completed 이벤트가 전달되기도 합니다.

import RxSwift
import UIKit

/*:
 # Observers
 */

// - 해당 Observable은 두개의 정수를 방출하고 종료합니다.
// - Observable은 이벤트를 전달하는데 이 이벤트는 Observer로 전달됩니다.
// Observer는 Observable에서 전달되는 이벤트를 감시하기위해 구독을 합니다. 그래서 Observer는 구독자라고도 부릅니다.
// - subscribe, 구독은 Observer와 Observable을 연결합니다. Observable~Observer 간 두 개를 연결해야 이벤트가 전달되므로 Observer는 중요한 요소 중 하나이빈다.

// Observable<Int>.create { (observer) -> Disposable in
//    observer.on(.next(0))
//    observer.onNext(1)
//
//    observer.onCompleted()
//
//    return Disposables.create()
// }
// .take(1)

let observer = Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)

    observer.onCompleted()
    return Disposables.create()
}

observer.subscribe {
    print("== Start ==")
    // - 해당 클로져로 이벤트가 전달되고, 이곳에서 직접 이벤트를 처리합니다.
    print($0) // next(0), next(1) 이 출력됩니다.

    // - next의 값을 접근하려면 .element를 접근해서 접근할 수 있습니다.
    if let element = $0.element {
        print(element)
    }
}

print("========*=========")
// - closure 인자값으로 next의 요소값이 바로 전달됩니다.
// - observer은 이벤트가 전달되는 순서를 정의합니다. observer가 구독을 하는 시점에 이벤트가 전달됩니다.
// 아래의 경우 subscribe을 하면서 closure를 전달하면 이벤트가 closure로 전달됩니다.
// - observer는 여러 이벤트를 동시에 전달하지 않습니다. 항상 하나의 이벤트가 처리된 이후 다음 이벤트가 전달되며 이 특성은 매우 중요하므로 알아두는게 좋습니다.

observer.subscribe(onNext: { element in
    print("== Start ==")
    print(element)
})

// Observable.from([1, 2, 3])
