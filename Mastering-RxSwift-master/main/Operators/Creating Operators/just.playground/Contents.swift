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

// MARK: - just operator

// - just는 하나의 항목을 방출하는 Observable을 생성합니다.
// - parameter로 하나의 요소를 받아서 Observable을 반환합니다.

import RxSwift
import UIKit

/*:
 # just
 */

let disposeBag = DisposeBag()
let element = "😀"

Observable.just(element)
    .subscribe { event in print(event) }
    .disposed(by: disposeBag)
// next(😀)
// completed

// - just 연산자의 paramter로 배열을 전달하면 배열 그대로 구독자에게 전달됩니다.
// - from 연산자와 자주 혼동할 수 있는데, just는 전달받은 요소를 그대로 Observable로 방출합니다.

Observable.just([1, 2, 3])
    .subscribe { event in print(event) }
    .disposed(by: disposeBag)

Observable.just(element)
    .subscribe { event in print(event) }
    .disposed(by: disposeBag)

Observable.just([1, 2, 3])
    .subscribe { event in print(event) }
    .disposed(by: disposeBag)
