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

// MARK: - timeout

// - timeout 정책을 부여합니다. timeout 설정 기간 내에 옵저버블 이벤트가 없다면 error 이벤트를 전달합니다.
// - 반배로 timeout 시간 내에 Observable이 발생하면 그대로 구독자에게 전달합니다.

import RxSwift
import UIKit

/*:
 # timeout
 */

let bag = DisposeBag()

let subject = PublishSubject<Int>()

// - timeout(.seconds(3), ......) 으로 설정한 뒤 3초 이내에 새로운 이벤트 전달이 되지 않는다면, error 이벤트를 구독자에게 전달하고 종료됩니다.
/*
 subject.timeout(.seconds(3), scheduler:
 MainScheduler.instance)
 .subscribe { print($0) }
 .disposed(by: bag)

 */
// - other을 설정하면, timeout이 발생 시 해당 지정 옵저버블로 구독대상이 변경되고 전달 된 뒤 completed 이벤트가 전달된 후 구독이 종료됩니다.
// result) next(0), next(0), completed
subject.timeout(.seconds(3),
                other: Observable.just(0),
                scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)

// - 타이머가 5초 이내에 시작하면 error이벤트가 방출되지 않지만 5초 이후 발생할 경우 error이벤트가 발생합니다.
// - 2초 시작시에는 문제 없지만, 5초 간격으로 7초 시간 대에는 5초를 초과하므로 error이벤트를 전달합니다.
Observable<Int>.timer(.seconds(2),
                      period: .seconds(5),
                      scheduler: MainScheduler.instance)
    .subscribe(onNext: { subject.onNext($0) })
    .disposed(by: bag)
