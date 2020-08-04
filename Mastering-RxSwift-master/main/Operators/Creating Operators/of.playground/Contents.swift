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

// MARK: of operator

// - of 연산자는 배열을 받아 배열 요소를 차례대로 전달합니다.

import RxSwift
import UIKit

/*
 /*:
  # of
  */

 let disposeBag = DisposeBag()
 let apple = "🍏"
 let orange = "🍊"
 let kiwi = "🥝"

 Observable.of(apple, orange, kiwi)
    .subscribe { element in print(element) }
    .disposed(by: disposeBag)

 Observable.of([1, 2], [3, 4], [5, 6])
    .subscribe { element in print(element) }
    .disposed(by: disposeBag)

 Observable.of(apple, orange, kiwi)
    .subscribe { element in print(element) }
    .disposed(by: disposeBag)

 Observable.of([1, 2], [3, 4], [5, 6])
    .subscribe { element in print(element) }
    .disposed(by: disposeBag)
 */

let fruits = ["apple", "banana", "grape", "melon", "strawberry"]
let melon = "melon"

struct CountDown: Sequence, IteratorProtocol {
    var count: Int

    // 구조체 내의 값을 구조체 내부에서 변화시키는 경우, mutating 키워드를 사용해야 내부에서 변화시킬 수 있습니다.
    mutating func next() -> Int? {
        if count == 0 {
            return nil
        }

        // 해당 블록이 종료 될 때 count는 1 감소 시킵니다.
        defer { count -= 1 }
        return count
    }
}

let threeToGo = CountDown(count: 3)

// result : 3, 2, 1
for index in threeToGo {
    print(index)
}
