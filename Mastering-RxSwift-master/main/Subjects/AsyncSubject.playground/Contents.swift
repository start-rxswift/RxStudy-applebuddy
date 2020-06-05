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

// MARK: - AsyncSubject

// - PublishSubject, ReplaySubject, BehaviorSubject는 subject로 이벤트가 전달되면 즉시 구독자에게 전달됩니다. 하지만 asyncSubject는 completed이벤트가 전달되기 전까지 구독자들에게 이벤트를 전달하지 않습니다.
// - AsyncSubject는 completed 이벤트를 전달받으면 가장 최근에 받은 이벤트를 구독자에게 전달합니다.
import RxCocoa
import RxSwift
import UIKit

/*:
 # AsyncSubject
 */

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

let subject = AsyncSubject<Int>()
subject.subscribe { print($0) }
    .disposed(by: disposeBag)

// - 아직 asyncSubject에 completed 이벤트가 전달되지 않았기 때문에 이 시점에 전달한 이벤트는 구독자에게 전달되지 않습니다.
subject.onNext(1)

subject.onNext(2)
subject.onNext(3)

// - error이벤트를 전달받으면 error이벤트만 구독자에게 전달되고 completed 이벤트 없이 종료됩니다.
// subject.onError(MyError.error)

// - subject로 completed이벤트를 전달하면 가장 최근의 이벤트, 3이 구독자에게 전달됩니다.
subject.onCompleted()
