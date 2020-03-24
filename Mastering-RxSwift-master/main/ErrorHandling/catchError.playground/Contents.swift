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

// MARK: catchError 연산자는 next이벤트, completed이벤트는 구독자에게 그대로 전달합니다. 반면 에러이벤트는 전달하지 않고 새로운 옵저버블이나 기본값을 전달합니다. 특히 네트워크 요청을 구현할때 많이 사용 됩니다.

import RxSwift
import UIKit

/*:
 # catchError
 */

let bag = DisposeBag()

enum MyError: Error {
    case error
}

let subject = PublishSubject<Int>()
let recovery = PublishSubject<Int>()

/*
subject
    .subscribe { print($0) }
    .disposed(by: bag)

// subject로 error 이벤트를 전달하면 그대로 전달됩니다. 구독이 종료 된 후 다른 이벤트를 전달되지 않습니다.
subject.onError(MyError.error)
*/

// 여기 catchError 연산자를 추가해 보겠습니다. 이 연산자는 클로져를 파라메터로 받습니다. 에러가 발생 시 새로운 옵저버블 이나 기본값을 전달합니다.
// catchError 클로져에서 recovery subject를 리턴합니다.
subject
    .catchError { _ in recovery }
    .subscribe { print($0) }
    .disposed(by: bag)

subject.onError(MyError.error) // catchError 를 넣은 뒤에는 onError 연산자를 사용해도 구독자에게 error 이벤트가 전달되지 않습니다. recovery subject로 교체되었기 때문입니다.

subject.onNext(11) // subject는 더이상 다른 이벤트를 전달하지 못하는 반면,
recovery.onNext(22) // recovery subject는 새로운 이벤트를 방출 할 수 있습니다. ( next(22) )
recovery.onCompleted() // 이 후 onCompleted() 를 실행하면 정상적으로 구독이 종료됩니다. ( completed )
