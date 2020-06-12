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

// MARK: - concat operator

// - 여러 옵저버블을 연결할 때 사용하는 연산자

import RxSwift
import UIKit

/*:
 # concat
 */

let disposeBag = DisposeBag()
let fruits = Observable.from(["🍏", "🍎", "🥝", "🍑", "🍋", "🍉"])
let animals = Observable.from(["🐶", "🐱", "🐹", "🐼", "🐯", "🐵"])

// - 타입메서드 concat 사용 예시)
// result : 과일들이 방출 후, 동물들이 차례로 연결되어 방출됩니다.
// - 인자값으로 전달된 모든 컬렉션을 모두 연결한 하나의 옵저버블을 만듭니다.
Observable.concat([fruits, animals])
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// - 인스턴스메서드 concat 사용 예시)
// result : 과일 컬렉션 + 동물 컬렉션
// - 위의 타입메서드 사용과 동일하게 옵저버블을 방출합니다.
fruits.concat(animals)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// result : 동물 컬렉션 + 과일 컬렉션
animals.concat(fruits)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
