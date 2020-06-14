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

// MARK: - interval operator

// - parameter : period, scheduler
// - 특정 주기마다 이벤트를 방출합니다.
// - interval operator의 특징은 특정 observable을 구독하는 시점마다 내부에 있는 timer가 시작되는 점입니다.

import RxSwift
import UIKit

/*:
 # interval
 */
// - 아래의 observable은 1초마다 MainScheduler에서 Int형 방출을 하는 Observable입니다.
let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

// dispose 메서드를 지정하지 않으면 1초마다 무한정으로 Int형 이벤트를 무한정으로 방출하게 됩니다.
let subscription = observable.subscribe { print("1 >> \($0)") }

// - 아래 코드는 구독한 observable의 이벤트 방출을 5초 뒤에 dispose() 시키는 코드입니다.
//   -> 이렇게 하면 5초 뒤 1초 단위로 이벤트를 방출하면 observable을 dispose 시킬 수 있게 됩니다.
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    subscription.dispose()
}

var subscription2: Disposable?

// - 2초 뒤 2번째 구독을 진행하고,
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    subscription2 = observable.subscribe { print("2 >> \($0)") }
}

// - 7초 뒤에 2번째 구독을 중지하겠습니다.
DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    subscription2?.dispose()
}
