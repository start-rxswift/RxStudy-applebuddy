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

// MARK: - ReplaySubject

// - PublishSubject, BehaviorSubject를 모두 이해했다면, ReplaySubject는 비교적 쉽게 이해할 수 있습니다.
// - ReplaySubject는 다수의 이벤트를 저장하고 구독자에게 전달할 수 있습니다.
// - ReplaySubject는 지정한 버퍼크기만큼의 최신이벤트를 저장하고 새로운 구독자에게 전달합니다. 버퍼는 메모리에 저장되기때문에 사용량을 신경써야하며 필요이상의 버퍼를 사용하지 않도록 주의해야합니다.
import RxSwift
import UIKit

/*:
 # ReplaySubject
 */

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

let rs = ReplaySubject<Int>.create(bufferSize: 3)

// 우선 subject로 10개의 next 이벤트를 전달해보겠습니다.
(1 ... 10).forEach { rs.onNext($0) }
rs.subscribe { print("Observer 1 >>", $0) }
    .disposed(by: disposeBag)

// - 결과적으로 3개의 next 이벤트, 8,9,10이 구독자에게 전달됩니다.
// - 3개의 next이벤트가 전달된 이유는 버퍼의 크기를 3으로 지정했기 때문입니다.

// 이후의 구독자에게도 동일한 next 이벤트를 전달하고 있습니다.
rs.subscribe { print("Observer 2 >>", $0) }
    .disposed(by: disposeBag)

// subject에 next이벤트를 전달하면 지금까지의 구독자들에게 11 이벤트를 전달합니다. 여기에 더해 버퍼에서 가장 오래된 이벤트가 삭제됩니다. 8, 9, 10 이 있다고 하면 8이 사라집니다.
rs.onNext(11)

// 이후 구독자에게는 9, 10, 11 이벤트가 전달됩니다.
rs.subscribe { print("Observer 3 >>", $0) }
    .disposed(by: disposeBag)

// ReplaySubject에 completed 이벤트를 전달하면 지금까지의 구독자들에게 completed 이벤트가 전달됩니다.
// ex) 9, 10, 11, completed
rs.onCompleted()

// onError 이벤트가 ReplaySubject에 전달되면 지금까지의 구독자들에게 error 이벤트를 전달합니다. 이후의 새로운 구독자는 버퍼 크기만큼의 새로운 이벤트를 전달받은 뒤 error 이벤트를 받게 됩니다. ex) 9, 10, 11, error
rs.onError(MyError.error)

// subject에 completed 이벤트 전달 이후의 새로운 구독자는 버퍼크기만큼의 최신 이벤트를 받고 completed 이벤트를 전달받습니다.
rs.subscribe { print("Observer 99 >>", $0) }
    .disposed(by: disposeBag)
