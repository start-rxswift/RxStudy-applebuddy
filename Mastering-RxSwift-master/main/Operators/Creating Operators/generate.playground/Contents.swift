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

// MARK: generate operator

// - generate 연산자는 4개의 인자값을 갖습니다.
//   - initialState(초기값), condition(true일때 요소를 방출, false면 completed이벤트 방출 후 종료), scheduler, iterate(값을 바꾸는 코드 감소/증가 시키는 등..)
import RxSwift
import UIKit

/*:
 # generate
 */

let disposeBag = DisposeBag()
let red = "🔴"
let blue = "🔵"

// - generate : 10보다 작거나 짝수인 observable을 방출 해보겠습니다.
// - 초기값, 0부터 해서 2씩 증가를 하며 condition 클로져의 조건이 true일 동안 연산된 요소값을 방출합니다.
//   - ex) 0, 2, 4, 6, 8, 10, completed
Observable.generate(initialState: 0, condition: { $0 <= 10 }, iterate: { $0 + 2 })
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// MARK: practice: 10에서 시작에서 2씩 감소, 0보다 크거나 같을때까지의 요소를 방출하기

// - ex) 10, 8, 6, 4, 2, 0, completed
Observable.generate(initialState: 10, condition: { $0 >= 0 }, iterate: { $0 - 2 })
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// - red, blue ball 문자열에 번갈아가면 출력해보겠습니다. 또한 최대길이는 14로 제한하겠습니다.
// - 현재 누적된 문자열의 길이에 따라 파란공, 빨간공을 누적시켜 빨강 파랑이 번갈아가며 출력되는 것을 볼 수 있습니다.
Observable.generate(initialState: red, condition: { $0.count < 15 }, iterate: { $0.count.isMultiple(of: 2) ? $0 + red : $0 + blue })
    .subscribe { print($0) }
    .disposed(by: disposeBag)
