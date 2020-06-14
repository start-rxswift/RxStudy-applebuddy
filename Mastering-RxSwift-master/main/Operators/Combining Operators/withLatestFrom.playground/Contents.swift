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

// MARK: - withLatestFrom operator

// - withLatestFrom operator는 triggerObservable.withLatestFrom(dataObservable) 형식으로 활용됩니다.
// triggerObservable이 next 이벤트를 방출하면, dataObservable이 가장 최근에 방출한 next이벤트를 구독자에게 전달합니다.
// ex) 예를들면, 회원가입 기능을 만들 때, 회원가입 완료 버튼을 누르면 현재 입력된 값들을 불러오고 싶을때 활용될 수 있습니다.

import RxSwift
import UIKit

/*:
 # withLatestFrom
 */

let disposeBag = DisposeBag()

enum MyError: Error {
    case error
}

// 먼저, withLAtestFrom 연산자 활용에 사용 될 triggerSubject, dataSubject가 선언됩니다.
let triggerSubject = PublishSubject<Void>()
let dataSubject = PublishSubject<String>()

// withLatestFrom operator 사용 예시
triggerSubject.withLatestFrom(dataSubject)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 아직 triggerSubject가 이벤트를 전달받지 않았으므로, dataSubject의 이벤트는 구독자에게 전달되지 않습니다.
dataSubject.onNext("Hello")
dataSubject.onNext("I'm MungGu!!")

// 이렇게 triggerSubject가 next이벤트를 전달받았을 때, dataSubject의 가장 최근 이벤트가 구독자에게 전달됩니다.
triggerSubject.onNext(())

// triggerSubject에 다시 next이벤트를 연이어 전달 하면, 이때 또한 dataSubject의 가장 최근 이벤트가 구독자에게 전달됩니다.
triggerSubject.onNext(())

// dataSubject가 completed이벤트를 전달 받았더라도, triggerSubject 이벤트 수신 시 dataSubject의 가장 최근 이벤트를 구독자에게 전달합니다.
// dataSubject.onCompleted()
//triggerSubject.onNext(())

// 하지만 completed 이벤트와 달리, dataSubject가 error 이벤트를 전달받으면 바로 구독자에게 error이벤트가 전달됩니다.
// triggerSubject가 직접 error 이벤트를 전달받아도 dataSubject가 error 이벤트를 전달받을때와 동일하게 구독자에게 error 이벤트가 전달됩니다.
dataSubject.onError(MyError.error)
