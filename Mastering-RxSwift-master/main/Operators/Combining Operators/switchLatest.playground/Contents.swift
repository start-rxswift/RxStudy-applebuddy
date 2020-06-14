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

// MARK: - switchLatest operator

// - 가장 최근 Observable이 방출하는 이벤트를 Subscriber에게 전달합니다.

import RxSwift
import UIKit

/*:
 # switchLatest
 */

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

let aSubject = PublishSubject<String>()
let bSubject = PublishSubject<String>()

// Observable을 방출하는 새로운 Subject를 만들겠습니다. -> 문자열을 방출하는 Observable을 방출하는 subject 입니다.
let source = PublishSubject<Observable<String>>()

// 먼저 source subject를 구독하겠습니다.
source
    .switchLatest()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

aSubject.onNext("1")
bSubject.onNext("b")

// 지금은 코드에서 source라는 subject만 구독중입니다. aSubject, bSubject는 구독하지 않고 있습니다.
// 또한 aSubject, bSubject와 source subject 사이에는 아무런 연관이 없는 상태입니다. 그러므로 현재는 아무것도 출력되지 않습니다.

// switchLatest operator 사용 전)
// - 이때 source subject에서 next이벤트로 aSubject를 방출하면 옵저버블이 방출됩니다.
// result : next(RxSwift.PublishSubject<Swift.String>)

// switchLatest operator 사용 후)
// - switchLatest 연산자는 별도의 인자값을 받지 않습니다. 또한 주로 옵저버블을 방출하는 옵저버블에 사용됩니다.
// - 이전 aSubject에서 방출한 "1"은 출력되지 않지만, 이후 aSubject에서 방출한 이벤트에 대해서 구독자에게 전달됩니다.
source.onNext(aSubject)

// - source subject가 switchLatest 연산자를 사용했을 경우, onNext에서 해당 옵저버블, aSubject을 방출한 이후, aSubject에서 방출하는 최신 이벤트가 구독자에게 전달됩니다.
// result : next(2), next(3)
aSubject.onNext("2")
aSubject.onNext("3")

// - 아직 bSubject는 source subject에서 방출되지 않은 옵저버블이므로 bSubject의 이벤트는 구독자에게 전달되지 않습니다.
bSubject.onNext("c")

// - bSubject 또한 source subject에서 방출하고 부터는 bSubject 이벤트가 최신 이벤트를 방출 시 구독자에게 해당 이벤트가 전달됩니다.
// * 이때 switchLatest 연산자는 aSubject에 대한 구독을 종료하고, bSubject에 대한 구독을 시작합니다.
source.onNext(bSubject)

// result: x
aSubject.onNext("aEvent!!")
// result: next(bEvent!!)
bSubject.onNext("bEvent!!")

// - 이때 aSubject, bSubject로 completed 이벤트를 전달해도 구독자에게 completed 이벤트가 전달되지 않습니다.
aSubject.onCompleted()
// bSubject.onCompleted()

// - 이렇게 source subject에 직접 completed이벤트를 전달해야 구독자에게 completed이벤트가 전달됩니다.
// source.onCompleted()

// - 하지만 error 이벤트는 조금 다릅니다. switchLatest 연산자가 구독중인 옵저버블에서 error이벤트를 전달받으면 바로 구독자에게 error이벤트가 전달됩니다.
aSubject.onError(MyError.error)
bSubject.onError(MyError.error)
