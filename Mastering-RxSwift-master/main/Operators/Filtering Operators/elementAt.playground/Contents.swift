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

// MARK: - elementAt operator

// - elementAt을 활용해 특정 인덱스 위치의 요소만 방출할 수 있습니다.
// - elementAt은 정수형 인덱스를 parameter로 받습니다.

import RxSwift
import UIKit

/*:
 # elementAt
 */

let disposeBag = DisposeBag()
let fruits = ["🍏", "🍎", "🍋", "🍓", "🍇"]

// - 아래의 경우 from 연산자만 사용하여 배열 내의 요소를 차례대로 방출합니다.
Observable.from(fruits)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// - elementAt에 특정 인덱스 정보를 전달해 특정 인덱스의 요소만 방출할 수 있습니다.
Observable.from(fruits)
    .elementAt(2)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
