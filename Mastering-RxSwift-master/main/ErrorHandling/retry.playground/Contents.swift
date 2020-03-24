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

// MARK: retry 연산자를 사용하면 옵저버블 에러가 발생 시 이전의 구독을 중단하고 새로운 구독을 시작합니다. 새로운 구독이 시작하므로, Observable 시퀀스는 처음부터 다시 시작합니다.
// 인자값을 안주면, 무한으로 재시도를 합니다. 이 경우 무한루프가 될 수 있기 때문에 가능한 피하고, 주의해야합니다.
// 두번째 형식으로는 최대 재시도횟수를 받아 설정할 수 있습니다.
// retry는 에러가 발생한 즉시 다시 처음부터 재시도 합니다. 이때 별도로 중간 처리를 하는 방법은 없습니다. 

import RxSwift
import UIKit

/*:
 # retry
 */

let bag = DisposeBag()

enum MyError: Error {
    case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
    let currentAttempts = attempts
    print("#\(currentAttempts) START")
    
    // attempts 값이 3보다 작으면 error를 방출하고, attempts값을 증가 시킵니다.
    if attempts < 3 {
        observer.onError(MyError.error)
        attempts += 1
    }

    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()

    return Disposables.create {
        print("#\(currentAttempts) END")
    }
}

// 처음, 두번째 시도는 실패하고 재시도 되며, 3번째에 완료됩니다. 만약 기저조건(최대 재시도 횟수)을 설정하지않으면 무한루프가 발생할 수 있어 주의해야 합니다. 재시도 횟수는 한번 에러가 발생한 후의 횟수부터 카운팅 되므로 재시도 횟수를 잘 판단하여 사용해야합니다.
source
    .retry(7)
    .subscribe { print($0) }
    .disposed(by: bag)
