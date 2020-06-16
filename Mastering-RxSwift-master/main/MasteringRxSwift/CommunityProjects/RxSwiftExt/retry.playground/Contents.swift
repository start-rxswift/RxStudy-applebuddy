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

// MARK: - retry operator

// - retry operator는 에러 발생 시 현재 구독을 중단하고, 새로운 구독을 시작합니다. 새로운 구독이 시작되기 떄문에 Observable 시퀀스는 새로 시작됩니다.

import RxSwift
import RxSwiftExt
import UIKit

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
    let currentAttempts = attempts
    // Sequcnce의 시작을 확인하는 로그를 출력
    print("#\(currentAttempts) START")

    // * 해당 재시도 횟수 제한 없이 Error가 계속 발생하는 상황에서 retry에 인자값 지정을 하지 않으면, 무한루프를 초래할 수 있습니다.
    if attempts > 0 {
        observer.onError(MyError.error)
        attempts += 1
    }

    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()

    return Disposables.create {
        // Sequence 의 끝을 확인하는 로그 출력
        print("#\(currentAttempts) END")
    }
}

// retry 연산자를 사용하면 error 발생 시 재시도를 합니다.
// - 만약 에러가 계속 발생하면 재시도를 반복하는 횟수가 증가하고, 이로서 불필요한 resource를 낭비할 수도 있습니다. 심한경우 무한루프를 초래하거나 앱 강제종료가 될 수도 있습니다.
//   - 그러프로 파라미터를 통해 최대 재시도횟수를 지정하는 것이 좋습니다. 최대 재시도 횟수를 인자값으로 지정할 수 있습니다.
// .  - retry의 최대 재시도 횟수 지정시에는 항상 재시로하려는 횟수 + 1을 인자값으로 넘겨주어야 합니다.
source
    .retry(7)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
