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

// MARK: - startWith operator

// - 요소 방출 전에 앞부분에 옵저버블을 추가하는데 사용합니다.
// - 주로 기본값, 시작값을 주고 시작하려 할 때 사용합니다.
// - startWith operator는 LIFO(Last In First Out) 방식으로 작동합니다.

import RxSwift
import UIKit

/*:
 # startWith
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5]

// result : -3, -1, -2, 0, 1, 2, 3, 4, 5
Observable.from(numbers)
    .startWith(0) // 맨 앞에 0이 추가되고,
    .startWith(-1, -2) // -1, -2가 0 앞에 추가되고
    .startWith(-3) // -1 앞에 -3이 추가됩니다.
    .subscribe { print($0) }
    .disposed(by: disposeBag)
