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

// MARK: - empty operator

// - empty, error 연산자가 생성하는 Observable은 next이벤트를 전달하지 않는 공통점이 있습니다. 다시말해, 어떠한 요소도 방출하지 않습니다.
// - empty 연산자는 next이벤트를 전달하지 않습니다.
// - empty 연산자 : completed 이벤트를 전달하는 옵저버블을 방출합니다.

import RxSwift
import UIKit

let disposeBag = DisposeBag()
/*:
 # empty
 */

Observable<Void>.empty()
    .subscribe { print($0) }
    .disposed(by: disposeBag)
// result: completed 이벤트가 전달됩니다. 옵저버가 아무런 동작 없이 종요해야할 때 사용됩니다.
