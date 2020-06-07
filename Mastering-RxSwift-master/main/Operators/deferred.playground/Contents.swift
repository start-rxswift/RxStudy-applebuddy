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

// MARK: - deferred operator

// - deferred 연산자는 특정 조건에 따라 Observable을 생성할 수 있습니다.
// - deferred 연산자는 옵저버블을 리턴하는 클로져를 인자값으로 받습니다.

import RxSwift
import UIKit

/*:
 # deferred
 */

let disposeBag = DisposeBag()
let animals = ["🐶", "🐱", "🐹", "🐰", "🦊", "🐻", "🐯"]
let fruits = ["🍎", "🍐", "🍋", "🍇", "🍈", "🍓", "🍑"]
var flag = true

// ex) flag는 true -> false가 되며, fruits 배열 요소가 방출 됨
let factory: Observable<String> = Observable.deferred {
    flag.toggle()

    if flag {
        return Observable.from(animals)
    } else {
        return Observable.from(fruits)
    }
}

// ex) flag는 false -> true가 되며, animals 배열 요소가 방출 됨
factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)

factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// ex) 다시 flag는 true -> false가 되며, fruits 배열 요소가 방출 됨
factory
    .subscribe { print($0) }
    .disposed(by: disposeBag)
