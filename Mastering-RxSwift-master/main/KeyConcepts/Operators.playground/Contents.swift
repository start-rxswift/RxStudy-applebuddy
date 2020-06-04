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

import RxSwift
import UIKit

/*:
 # Operators
 */

let disposeBag = DisposeBag()

// - 연산자(Operator)는 보통 subscribe { } 이전에 사용합니다.
// take 연산자는 옵저버블에서 파라미터에서 지정한 특정 갯수만 옵저버블로 다시 생성해주는 연산자입니다.
// 쉽게 말해, 아래의 경우 처음 요소 5개만 전달합니다.
Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
    .take(5) // 1, 2, 3, 4, 5
    .filter { $0.isMultiple(of: 2) } // 2, 4
    .subscribe { print($0) }
    .disposed(by: disposeBag) // completed

Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
    .filter { $0.isMultiple(of: 2) } // 2, 4, 6, 8
    .take(3) // 2, 4, 6
    .subscribe { print($0) }
    .disposed(by: disposeBag) // completed
