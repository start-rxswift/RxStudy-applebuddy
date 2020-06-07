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

// MARK: - error operator

// - error 연산자는 error 이벤트를 전달하고 종료하는 Observable을 방출합니다.
// - error 연산자는 empty 연산자와 같이 next이벤트를 전달하지 않는다는 특징이 있습니다.
// - error 연산자는 주로 error를 처리할때 활용됩니다.

import RxSwift
import UIKit

/*:
 # error
 */

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

Observable<Void>.error(MyError.error)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
// result) 결과적으로 error(error) 이벤트가 전달되고 종료됩니다.
