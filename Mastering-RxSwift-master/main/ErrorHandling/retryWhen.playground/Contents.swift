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

// MARK: retryWhen operator

// - 연산자는 retry 연산자와 달리 에러가 발생 시 trigger Observable이 방출함에 따라 재시도를 진행하며 클로져를 인자로 받습니다.

import RxSwift
import UIKit

/*:
 # retryWhen
 */

let bag = DisposeBag()

enum MyError: Error {
    case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
    let currentAttempts = attempts
    print("START #\(currentAttempts)")

    if attempts < 3 {
        observer.onError(MyError.error)
        attempts += 1
    }

    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()

    return Disposables.create {
        print("END #\(currentAttempts)")
    }
}

let trigger = PublishSubject<Void>()

// 에러가 발생했을때 바로 재시도를 하는 retry와 달리, retryWhen은 trigger Observable이 next이벤트를 전달할 때까지 대기합니다.
source
    .retryWhen { _ in trigger }
    .subscribe { print($0) }
    .disposed(by: bag)

// retry 연산자 대신 retryWhen 연산자를 활용하면 에러발생 시 바로 재시도를 하는 것이 아닌 trigger가 Observable을 방출할때마다 재시도를 합니다.
trigger.onNext(()) // 한번 재시도 후 대기
trigger.onNext(()) // 두번째 재시도 후 대기
