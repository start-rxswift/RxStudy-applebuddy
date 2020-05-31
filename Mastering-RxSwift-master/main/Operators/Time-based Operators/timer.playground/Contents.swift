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

// MARK: - timer

// - timer 연산자는 interval 과 마찬가지로 정수를 반복적으로 방출하는 Observable을 생산합니다.
// - 히지만 지연방식과 반복주기를 동시에 설정할 수 있고, 두 값에 따라 동작방식이 달라집니다.

import RxSwift
import UIKit

/*:
 # timer
 */

let bag = DisposeBag()

// MARK: parameter

// - dueTime: RxTimeInterval : 첫번째 요소가 방출되는 시점까지의 상대적 시간, 구독을 시작하고 첫번째 - 요소가 구독자에게 전달되는 시간, 아래의 경우 첫번째 요소가 구독 후 1초 뒤에 전달된다.
// - period: RxTimeInterval? = nil : 반복주기
// - scheduler : 타이머를 전달할 스케쥴러

// 기본 타이머 실행 예시
// Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.instance)
//    .subscribe { print($0) }
//    .disposed(by: bag)

// * period를 .milliseconds(500)으로 설정하면 1초 마다 타이머가 실행됩니다.
Observable<Int>.timer(.seconds(1),
                      period: .milliseconds(1000),
                      scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)
