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

// MARK: - skipWhile operator

// - 인자로 클로저를 받으며, false를 리턴하는 동안 방출하는 요소를 무시합니다.
import RxSwift
import UIKit

/*:
 # skipWhile
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// - skipWhile은 받은 클로저가 false를 리턴한 후의 요소를 전달합니다. true를 리턴하는동안 방출하는 요소는 무시합니다.
// 홀수가 아닌 값이 들어온 후부터 요소 방출
// 1(무시), 2(이후 전달), 3, 4. 5. 6, 7, 8, 9, 10
Observable.from(numbers)
    .skipWhile { !$0.isMultiple(of: 2) }
    .subscribe { print($0) }
    .disposed(by: disposeBag)
