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

// MARK: - sample operator

// - sample operator는 withLatestFrom과 반대로 dataSubject에서 사용하며 triggerSubject를 인자로 받아 사용합니다.
// - withLatestFrom 연산자는 sample operator와 반대로 triggerSubject에서 접근하여 사용하며, dataSubject를 인자로 받아 사용합니다.

import RxSwift
import UIKit

/*:
 # sample
 */

enum MyError: Error {
    case error
}

let disposeBag = DisposeBag()

let triggerSubject = PublishSubject<Void>()
let dataSubject = PublishSubject<String>()

dataSubject.sample(triggerSubject)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// - 아직 dataSubject가 방출한 next 이벤트가 없기 때문에 triggerSubject가 next이벤트를 방출해도 구독자에게 전달되는 이벤트는 없습니다.
triggerSubject.onNext(())

// - dataSubject가 next이벤트를 전달했다고 해당 이벤트가 구독자에게 바로 전달되는 것은 아닙니다.
dataSubject.onNext("Hello!")

// - 이렇게 dataSubject가 next이벤트를 전달한 뒤 triggerSubject가 next이벤트를 전달해야만 구독자에게 이벤트가 전달됩니다.
triggerSubject.onNext(())
// - 하지만, withLatestFrom 연산자와의 차이점은, dataSubject의 이벤트 방출 이후 triggerSubject에서 이벤트를 여러번 방출해도 처음 단 한번의 이벤트만 구독자에게 전달됩니다. 다시말해, 아래의 두번의 next이벤트 이후에 구독자에게 별도의 이벤트는 전달되지 않습니다.
triggerSubject.onNext(())
triggerSubject.onNext(())

// * withLatestFrom 연산자는 completed 대신 최신 next 이벤트를 전달했지만, sample연산자는 completed이벤트를 그대로 전달합니디.
// dataSubject.onCompleted()
//triggerSubject.onNext(())

// - 아래와 같이 dataSubject가 에러이벤트를 전달받으면 triggerSubject의 이벤트 방출과 상관없이 구독자에게 error이벤트가 방출됩니다.
dataSubject.onError(MyError.error)
