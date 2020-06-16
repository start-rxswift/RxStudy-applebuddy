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

// MARK: catchErrorJustReturn operator

// - catchErrorJustReturn 연산자는 catchError 와 달리 에러 발생 시 새로운 옵저버블 대신 기본값을 리턴하는 연산자입니다.
// - catchError operator와 달리, 에러 발생 시 발생할 기본값을 지정하므로 어떤 에러 상황에서던 동일한 값을 리턴하는 단점이 있습니다.
//   - catchError, catchErrorJustReturn과 달리 에러 발생시 작업을 재시작하고 싶다면, retry operator를 활용할 수 있습니다.

import RxSwift
import UIKit

let bag = DisposeBag()

enum MyError: Error {
    case error
}

let subject = PublishSubject<Int>()

// - catchErrorJustReturn 연산자는 에러발생시 파라메터로 전달한 값(-1)을 전달합니다. 이 값은 subject가 전달하는 타입을 따라갑니다.
subject
    .catchErrorJustReturn(-1)
    .subscribe { print($0) }
    .disposed(by: bag)

// - catErrorJustReturn은 에러 시 지정값을 방출한 이후 별도로 할 게 없으므로 이후 completed이벤트를 전달하고 구독이 종료됩니다.
// result : next(-1)
subject.onError(MyError.error)
