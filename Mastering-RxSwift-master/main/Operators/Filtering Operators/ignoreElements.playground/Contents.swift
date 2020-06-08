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

// MARK: - ignoreElements operator

// - Observable이 방출하는 next이벤트를 필터링해서 completed, error 이벤트만 구독자에게 전달합니다.
// - 주로 completed, error 유무만 확인하고자 할때 ignoreElement operator를 사용합니다.

import RxSwift
import UIKit

/*:
 # ignoreElements
 */

let disposeBag = DisposeBag()
let fruits = ["🍏", "🍎", "🍋", "🍓", "🍇"]

// - 단순 from 연산자만 사용해서 fruits 배열을 전달하면, 배열 요소가 차례대로 방출됩니다.
Observable.from(fruits)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// - 이때 ignoreElements를 사용하면 next 이벤트는 필터링되고, error, completed 이벤트만 구독자에게 전달됩니다.
// - 아래의 경우 next 이벤트 없이 completed 이벤트만 구독자에게 전달합니다.
Observable.from(fruits)
    .ignoreElements()
    .subscribe { print($0) }
    .disposed(by: disposeBag)
