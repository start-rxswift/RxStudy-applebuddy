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

// MARK: - PublishSubject

// - PublishSubject는 subject로 전돨되는 이벤트를 Observer에게 전달하는 가장 기본적인 형태의 subject입니다.

import RxSwift
import UIKit

/*:
 # PublishSubject
 */

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

// 여기서는 String의 Next 이벤트를 받아서 다른 옵저버에게 전달할 수 있습니다.
// subject는 Observable인 동시에 Observer입니다. 다른 소스로부터 이벤트를 전달받거나 옵저버로 이벤트를 전달할 수도 있습니다. subject역시 옵저버이기 때문에 onNext를 사용할 수 있습니다.
let subject = PublishSubject<String>()

// subject는 Observable인 동시에 다른 Observer가 구독할 수 있습니다.
subject.onNext("Hello")

// 여전히 콘솔에는 아무것도 출력하지 않습니다. publishSubject는 구독이후에 전달되는 이벤트만 전달하기 떄문입니다.
let observer = subject.subscribe { print(">> 1", $0) }
observer.disposed(by: disposeBag)

// 다시 subject로 next 이벤트를 전달하겠습니다.
// RxSwift를 담은 next 이벤트가 subject로 전달되고, subject는 해당 이벤트를 구독자에게 전달합니다.
subject.onNext("RxSwift")

// observer2 는 두개의 next이벤트가 전달 된 이후에 구독을 시작했기때문에 이 시점에는 아무런 이벤트도 전달받지 못합니다.
let observer2 = subject.subscribe { print(">> 2", $0) }
observer2.disposed(by: disposeBag)

// 이후에 다시 onNext 이벤트를 전달하면, 해당 이벤트는 observer, observer2 옵저버 모두에게 전달됩니다.
subject.onNext("subject")

// 이어서 subject로 completed 이벤트를 전달해 보겠습니다.
// 그러면 모든 구독자에게 completed 이벤트가 전달됩니다.
subject.onCompleted()
// subject.onError(MyError.error)

// completed 이벤트 이후에 구독자를 추가하면 어떻게 될까요?
// observer3는 subject를 구독하는 즉시 completed이벤트를 전달받습니다.
// 만약 onCompleted() 가 아닌 onError()가 전달된다면 이후의 구독자도 모두 error 이벤트를 전달받게 됩니다.
let observer3 = subject.subscribe { print(">> 3", $0) }
observer3.disposed(by: disposeBag)
