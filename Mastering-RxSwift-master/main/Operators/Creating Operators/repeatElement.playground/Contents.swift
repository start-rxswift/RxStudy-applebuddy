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

// MARK: - repeatElement operator

// - repeatElement operator는 인자값으로 받은 요소를 무한정으로 방출합니다.

import RxSwift
import UIKit

/*:
 # repeatElement
 */

let disposeBag = DisposeBag()
let element = "❤️"

// - element를 무한정(무한루프)으로 방출하게 됩니다.
// - 그러므로 repeatElement 연산자 사용 시 방출되는 요소를 제한해 주는것이 중요합니다.
//   - repeatElement 연산자 사용에 앞서, take 연산자를 사용해서 방출 갯수를 지정하는 등의 제한을 통해 repeatElement의 무한 루프를 방지 할 수 있습니다.
// -> 최초 7개의 하트 문자열을 방출 후 completed 이벤트가 전달된 후 종료됩니다.
Observable.repeatElement(element)
    .take(7)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
